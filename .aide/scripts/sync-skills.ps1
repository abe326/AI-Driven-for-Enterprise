<#
.SYNOPSIS
  sync-skills.ps1 - .aide/ の正本から各AIツール用ラッパーを生成する（PowerShell版・Windows 11 / WSL2不要）

.DESCRIPTION
  bash版 sync-skills.sh と同一の出力を生成する。
  出力先（2系統に集約）:
    .claude/skills/   … Claude Code 用スキルラッパー
    .claude/agents/   … Claude Code 用レビューエージェント
    .agents/skills/   … GitHub Copilot + Codex 用スキルラッパー
  正本（編集しない・不可侵のフレームワーク核）:
    .aide/skills/   コアスキル
    .aide/agents/   レビューエージェント
  カスタマイズは .aide/ の外で行う（.aide/ は一切編集しない）:
    - 独自スキル        … .claude/skills/ ・ .agents/skills/ に直接作成（sync 対象外＝消さない・上書きしない）
    - プロジェクトルール … CLAUDE.md / AGENTS.md に直接記述
    - 成果物テンプレート … .aide-templates/（プロジェクト直下）に上書きを置く（スキルが実行時に優先読込）
  成果物カタログ/雛形（.aide/templates/, .aide-templates/）は実行時読み込みのため対象外。

.PARAMETER Target
  all（既定） / claude / agents

.EXAMPLE
  pwsh -File .aide/scripts/sync-skills.ps1
  pwsh -File .aide/scripts/sync-skills.ps1 claude
  pwsh -File .aide/scripts/sync-skills.ps1 agents
#>

param([ValidateSet('all', 'claude', 'agents')][string]$Target = 'all')

$ErrorActionPreference = 'Stop'

$ScriptDir   = $PSScriptRoot
$AideDir     = Split-Path $ScriptDir -Parent
$ProjectRoot = Split-Path $AideDir -Parent
$SkillsSrc   = Join-Path $AideDir 'skills'
$AgentsSrc   = Join-Path $AideDir 'agents'

function Get-FrontmatterField {
    param([string]$File, [string]$Field)
    $count = 0
    foreach ($line in (Get-Content -LiteralPath $File)) {
        if ($line -eq '---') { $count++; if ($count -eq 2) { break }; continue }
        if ($count -eq 1 -and $line.StartsWith("${Field}:")) {
            return ($line.Substring($Field.Length + 1)).Trim()
        }
    }
    return ''
}

function Resolve-WrapperDescription {
    param([string]$File)
    $short = Get-FrontmatterField -File $File -Field 'short_description'
    if ($short) { return $short }
    return (Get-FrontmatterField -File $File -Field 'description')
}

# ─── スキルのプリフェッチ（コア正本のみ） ───────────────────
function Get-SkillDirs {
    param([string]$Base)
    if (-not (Test-Path $Base)) { return @() }
    Get-ChildItem -LiteralPath $Base -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
        ForEach-Object { $_.Name }
}

$skills = @{}
foreach ($s in (Get-SkillDirs $SkillsSrc | Sort-Object)) {
    $file = Join-Path (Join-Path $SkillsSrc $s) 'SKILL.md'
    $name = Get-FrontmatterField -File $file -Field 'name'
    if (-not $name) { $name = $s }
    $skills[$s] = [pscustomobject]@{
        Name = $name
        Desc = (Resolve-WrapperDescription -File $file)
    }
}
$skillNames = $skills.Keys | Sort-Object

function Write-Utf8 {
    param([string]$Path, [string]$Content)
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding $false))
}

function Generate-ClaudeSkills {
    $dest = Join-Path $ProjectRoot '.claude/skills'
    foreach ($s in $skillNames) {
        $sk = $skills[$s]
        $content = "---`nname: $($sk.Name)`ndescription: $($sk.Desc)`n---`n`n@../../.aide/skills/$s/SKILL.md`n"
        Write-Utf8 -Path (Join-Path $dest "$s/SKILL.md") -Content $content
    }
    Write-Host "  Claude Code: $($skillNames.Count) スキルラッパー -> .claude/skills/" -ForegroundColor Green
}

function Generate-AgentsSkills {
    $dest = Join-Path $ProjectRoot '.agents/skills'
    foreach ($s in $skillNames) {
        $sk = $skills[$s]
        $content = "---`nname: $($sk.Name)`ndescription: $($sk.Desc)`n---`n`n以下のスキル定義に従って実行してください。`n正本: ../../.aide/skills/$s/SKILL.md`n"
        Write-Utf8 -Path (Join-Path $dest "$s/SKILL.md") -Content $content
    }
    Write-Host "  Copilot+Codex: $($skillNames.Count) スキルラッパー -> .agents/skills/" -ForegroundColor Green
}

function Generate-ClaudeAgents {
    $dest = Join-Path $ProjectRoot '.claude/agents'
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
    $count = 0
    if (Test-Path $AgentsSrc) {
        foreach ($f in (Get-ChildItem -LiteralPath $AgentsSrc -Filter '*.md' -File)) {
            Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dest $f.Name) -Force
            $count++
        }
    }
    Write-Host "  Claude Code: $count レビューエージェント -> .claude/agents/" -ForegroundColor Green
}

# ─── aide 管理外スキルの情報表示 ───────────────────────────
# コア正本に無いものは「ユーザー独自スキル」。sync は触らない（消さない・上書きしない）。
function Report-UserSkills {
    $found = $false
    foreach ($dir in @((Join-Path $ProjectRoot '.claude/skills'), (Join-Path $ProjectRoot '.agents/skills'))) {
        if (-not (Test-Path $dir)) { continue }
        foreach ($w in (Get-ChildItem -LiteralPath $dir -Directory)) {
            if (-not (Test-Path (Join-Path $SkillsSrc $w.Name))) {
                Write-Host "  ユーザー独自スキル（aide管理外・保持）: $($w.FullName)" -ForegroundColor DarkGray; $found = $true
            }
        }
    }
    $caDir = Join-Path $ProjectRoot '.claude/agents'
    if (Test-Path $caDir) {
        foreach ($f in (Get-ChildItem -LiteralPath $caDir -Filter '*.md' -File)) {
            if (-not (Test-Path (Join-Path $AgentsSrc $f.Name))) {
                Write-Host "  ユーザー独自エージェント（aide管理外・保持）: $($f.FullName)" -ForegroundColor DarkGray; $found = $true
            }
        }
    }
    if (-not $found) { Write-Host "  なし" -ForegroundColor DarkGray }
}

Write-Host ""
Write-Host "aide sync-skills (PowerShell)"
Write-Host "============================="
Write-Host "正本: .aide/skills/ = $($skillNames.Count) スキル / .aide/agents/"
Write-Host ""

switch ($Target) {
    'claude' { Generate-ClaudeSkills; Generate-ClaudeAgents }
    'agents' { Generate-AgentsSkills }
    'all'    { Generate-ClaudeSkills; Generate-ClaudeAgents; Generate-AgentsSkills }
}

Write-Host ""
Write-Host "aide管理外（ユーザー独自・保持対象）:"
Report-UserSkills
Write-Host ""
Write-Host "完了" -ForegroundColor Green
