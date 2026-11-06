[CmdletBinding()]
param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-Release {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { $failures.Add($Message) }
}

$required = @(
    '.gitignore',
    'README.md',
    'THIRD_PARTY_NOTICES.md',
    'MANIFEST.sha256',
    'docs/PROVENANCE.zh-CN.md',
    'docs/SOURCE_SHA256.txt',
    'docs/TEST_REPORT.zh-CN.md',
    'skills/ecomi-aplus-remix/SKILL.md',
    'skills/ecomi-aplus-remix/agents/openai.yaml',
    'skills/ecomi-aplus-remix/references/production-workflow.md',
    'skills/ecomi-aplus-remix/references/quality-gate.md'
)

foreach ($relative in $required) {
    Assert-Release (Test-Path -LiteralPath (Join-Path $RepoRoot $relative) -PathType Leaf) "缺少文件: $relative"
}

$skillRoot = Join-Path $RepoRoot 'skills/ecomi-aplus-remix'
$skillPath = Join-Path $skillRoot 'SKILL.md'
if (Test-Path -LiteralPath $skillPath) {
    $skill = Get-Content -Raw -LiteralPath $skillPath
    Assert-Release ($skill -match '(?s)^---\s*\r?\nname:\s*ecomi-aplus-remix\s*\r?\ndescription:\s*.+?\r?\n---') 'SKILL.md frontmatter 缺少有效 name/description'
    Assert-Release ((Split-Path -Leaf $skillRoot) -eq 'ecomi-aplus-remix') 'Skill 目录名与 frontmatter name 不一致'

    $links = [regex]::Matches($skill, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($match in $links) {
        $target = $match.Groups[1].Value
        if ($target -notmatch '^(https?://|#)') {
            Assert-Release (Test-Path -LiteralPath (Join-Path $skillRoot $target)) "SKILL.md 内部引用失效: $target"
        }
    }
}

if (Test-Path -LiteralPath $skillRoot) {
    $skillManifests = @(Get-ChildItem -Recurse -File -LiteralPath $skillRoot -Filter 'SKILL.md')
    Assert-Release ($skillManifests.Count -eq 1) "Skill 包必须且只能包含一个 SKILL.md，实际: $($skillManifests.Count)"

    $runtimeText = Get-ChildItem -Recurse -File -LiteralPath $skillRoot | Where-Object { $_.Extension -in '.md', '.yaml', '.yml', '.txt', '.ps1', '.py', '.js' }
    foreach ($file in $runtimeText) {
        $text = Get-Content -Raw -LiteralPath $file.FullName
        Assert-Release ($text -notmatch '(?i)[A-Z]:\\') "运行时文件含 Windows 绝对路径: $($file.FullName)"
        Assert-Release ($text -notmatch '(?i)(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})') "疑似敏感令牌: $($file.FullName)"
    }
}

$openaiYaml = Join-Path $skillRoot 'agents/openai.yaml'
if (Test-Path -LiteralPath $openaiYaml) {
    $yaml = Get-Content -Raw -LiteralPath $openaiYaml
    Assert-Release ($yaml -match 'display_name:\s*".+"') 'openai.yaml 缺少 display_name'
    Assert-Release ($yaml -match 'short_description:\s*".{25,64}"') 'openai.yaml short_description 应为 25-64 字符'
    Assert-Release ($yaml -match 'default_prompt:\s*"[^"\r\n]*\$ecomi-aplus-remix[^"\r\n]*"') 'openai.yaml default_prompt 必须显式包含 $ecomi-aplus-remix'
}

$manifestPath = Join-Path $RepoRoot 'MANIFEST.sha256'
if (Test-Path -LiteralPath $manifestPath) {
    foreach ($line in Get-Content -LiteralPath $manifestPath) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -notmatch '^([0-9a-f]{64})  (.+)$') {
            $failures.Add("无效清单行: $line")
            continue
        }
        $expected, $relative = $Matches[1], $Matches[2]
        $path = Join-Path $RepoRoot $relative
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $failures.Add("清单文件不存在: $relative")
            continue
        }
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()
        Assert-Release ($actual -eq $expected) "SHA-256 不匹配: $relative"
    }
}

if ($failures.Count -eq 0 -and (Test-Path -LiteralPath $skillRoot)) {
    $tempBase = [IO.Path]::GetTempPath()
    $tempInstall = Join-Path $tempBase ('feremo-skill-install-' + [guid]::NewGuid().ToString('N'))
    try {
        $dest = Join-Path $tempInstall '.codex/skills/ecomi-aplus-remix'
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
        Copy-Item -Recurse -LiteralPath $skillRoot -Destination $dest
        $sourceFiles = Get-ChildItem -Recurse -File -LiteralPath $skillRoot
        foreach ($source in $sourceFiles) {
            $relative = $source.FullName.Substring($skillRoot.Length + 1)
            $installed = Join-Path $dest $relative
            Assert-Release (Test-Path -LiteralPath $installed -PathType Leaf) "安装模拟缺少: $relative"
            if (Test-Path -LiteralPath $installed -PathType Leaf) {
                $a = (Get-FileHash -Algorithm SHA256 -LiteralPath $source.FullName).Hash
                $b = (Get-FileHash -Algorithm SHA256 -LiteralPath $installed).Hash
                Assert-Release ($a -eq $b) "安装模拟哈希不一致: $relative"
            }
        }
    }
    finally {
        $resolvedTemp = [IO.Path]::GetFullPath($tempInstall)
        Assert-Release ($resolvedTemp.StartsWith([IO.Path]::GetFullPath($tempBase), [StringComparison]::OrdinalIgnoreCase)) '临时清理路径越界'
        if (Test-Path -LiteralPath $tempInstall) { Remove-Item -Recurse -Force -LiteralPath $tempInstall }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    Write-Host "FAIL: $($failures.Count) 项"
    exit 1
}

Write-Host 'PASS: 元数据、引用、敏感信息、运行时路径、SHA-256 与安装模拟均通过。'
exit 0
