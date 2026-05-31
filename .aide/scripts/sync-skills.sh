#!/usr/bin/env bash
#
# sync-skills.sh
# .aide/ の正本から各AIツール用のラッパーを一括生成する（bash版）
#
# 出力先（2系統に集約）:
#   .claude/skills/   … Claude Code 用スキルラッパー
#   .claude/agents/   … Claude Code 用レビューエージェント
#   .agents/skills/   … GitHub Copilot + Codex 用スキルラッパー
#
# 正本（編集しない・不可侵のフレームワーク核）:
#   .aide/skills/   コアスキル
#   .aide/agents/   レビューエージェント
#
# カスタマイズは .aide/ の外で行う（.aide/ は一切編集しない）:
#   - 独自スキル        … .claude/skills/ ・ .agents/skills/ に直接作成（sync 対象外＝消さない・上書きしない）
#   - プロジェクトルール … CLAUDE.md / AGENTS.md に直接記述
#   - 成果物テンプレート … .aide-templates/（プロジェクト直下）に上書きを置く（スキルが実行時に優先読込）
#
# 使い方:
#   bash .aide/scripts/sync-skills.sh          # 全ツール向けに生成
#   bash .aide/scripts/sync-skills.sh claude    # Claude Code用のみ
#   bash .aide/scripts/sync-skills.sh agents    # Copilot + Codex（.agents/）のみ
#
# 注意: 成果物カタログ/雛形（.aide/templates/, .aide-templates/）はスキルが
#       実行時に直接読むため sync の対象外（編集すれば即反映される）。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AIDE_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$AIDE_DIR")"

SKILLS_SRC="$AIDE_DIR/skills"
AGENTS_SRC="$AIDE_DIR/agents"
TARGET="${1:-all}"

green() { printf '\033[32m%s\033[0m\n' "$1"; }
yellow() { printf '\033[33m%s\033[0m\n' "$1"; }
dim() { printf '\033[2m%s\033[0m\n' "$1"; }

# SKILL.md からフロントマターの1フィールドを抽出
extract_field() {
    local file="$1" field="$2"
    awk -v f="$field" '
        /^---$/ { c++; if (c == 2) exit; next }
        c == 1 && index($0, f ":") == 1 {
            sub("^" f ": *", "")
            print
            exit
        }
    ' "$file"
}

# ラッパー用 description（short_description 優先、無ければ description）
resolve_wrapper_description() {
    local file="$1" short_desc description
    short_desc=$(extract_field "$file" "short_description")
    if [ -n "$short_desc" ]; then
        printf '%s' "$short_desc"
    else
        description=$(extract_field "$file" "description")
        printf '%s' "$description"
    fi
}

# ─── スキルのプリフェッチ（コア正本のみ） ──────────────────
declare -a ALL_SKILLS
declare -A SKILL_NAME SKILL_WRAPPER_DESC

list_skill_dirs() {
    local base="$1"
    [ -d "$base" ] || return 0
    find "$base" -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
        [ -f "$dir/SKILL.md" ] && basename "$dir"
    done
}

prefetch_skills() {
    local skill file name desc
    for skill in $(list_skill_dirs "$SKILLS_SRC"); do
        file="$SKILLS_SRC/$skill/SKILL.md"
        name=$(extract_field "$file" "name")
        desc=$(resolve_wrapper_description "$file")
        ALL_SKILLS+=("$skill")
        SKILL_NAME[$skill]="${name:-$skill}"
        SKILL_WRAPPER_DESC[$skill]="$desc"
    done
}

# ─── Claude Code 用スキルラッパー ─────────────────────────
generate_claude_skills() {
    local dest="$PROJECT_ROOT/.claude/skills"
    mkdir -p "$dest"
    local skill name description
    for skill in "${ALL_SKILLS[@]}"; do
        name="${SKILL_NAME[$skill]}"; description="${SKILL_WRAPPER_DESC[$skill]}"
        mkdir -p "$dest/$skill"
        cat > "$dest/$skill/SKILL.md" <<WRAPPER
---
name: ${name}
description: ${description}
---

@../../.aide/skills/${skill}/SKILL.md
WRAPPER
    done
    green "  Claude Code: ${#ALL_SKILLS[@]} スキルラッパー → .claude/skills/"
}

# ─── Copilot + Codex 用スキルラッパー（.agents/） ─────────
generate_agents_skills() {
    local dest="$PROJECT_ROOT/.agents/skills"
    mkdir -p "$dest"
    local skill name description
    for skill in "${ALL_SKILLS[@]}"; do
        name="${SKILL_NAME[$skill]}"; description="${SKILL_WRAPPER_DESC[$skill]}"
        mkdir -p "$dest/$skill"
        cat > "$dest/$skill/SKILL.md" <<WRAPPER
---
name: ${name}
description: ${description}
---

以下のスキル定義に従って実行してください。
正本: ../../.aide/skills/${skill}/SKILL.md
WRAPPER
    done
    green "  Copilot+Codex: ${#ALL_SKILLS[@]} スキルラッパー → .agents/skills/"
}

# ─── Claude Code 用レビューエージェント（全文コピー） ──────
# エージェント定義は @import ではなく実体が必要なため全文を配置する
generate_claude_agents() {
    local dest="$PROJECT_ROOT/.claude/agents"
    mkdir -p "$dest"
    local f count=0
    if [ -d "$AGENTS_SRC" ]; then
        for f in "$AGENTS_SRC"/*.md; do
            [ -f "$f" ] || continue
            cp "$f" "$dest/$(basename "$f")"
            count=$((count + 1))
        done
    fi
    green "  Claude Code: ${count} レビューエージェント → .claude/agents/"
}

# ─── aide 管理外スキルの情報表示 ───────────────────────────
# .claude/skills, .agents/skills 配下でコア正本に無いものは「ユーザー独自スキル」。
# sync は触らない（消さない・上書きしない）。エラーではなく情報として表示する。
report_user_skills() {
    local found=0 dir wrapper_dir skill_name
    for dir in "$PROJECT_ROOT/.claude/skills" "$PROJECT_ROOT/.agents/skills"; do
        [ -d "$dir" ] || continue
        while IFS= read -r wrapper_dir; do
            skill_name=$(basename "$wrapper_dir")
            if [ ! -d "$SKILLS_SRC/$skill_name" ]; then
                dim "  ユーザー独自スキル（aide管理外・保持）: $wrapper_dir"; found=1
            fi
        done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d)
    done
    if [ -d "$PROJECT_ROOT/.claude/agents" ]; then
        local agent_file agent_name
        while IFS= read -r agent_file; do
            agent_name=$(basename "$agent_file")
            if [ ! -f "$AGENTS_SRC/$agent_name" ]; then
                dim "  ユーザー独自エージェント（aide管理外・保持）: $agent_file"; found=1
            fi
        done < <(find "$PROJECT_ROOT/.claude/agents" -mindepth 1 -maxdepth 1 -type f -name '*.md')
    fi
    [ "$found" -eq 0 ] && dim "  なし"
}

# ─── メイン ────────────────────────────────────────────────
prefetch_skills

echo ""
echo "aide sync-skills (bash)"
echo "======================="
echo "正本: .aide/skills/ = ${#ALL_SKILLS[@]} スキル / .aide/agents/"
echo ""

case "$TARGET" in
    claude)
        generate_claude_skills
        generate_claude_agents
        ;;
    agents)
        generate_agents_skills
        ;;
    all)
        generate_claude_skills
        generate_claude_agents
        generate_agents_skills
        ;;
    *)
        echo "使い方: $0 [all|claude|agents]"
        exit 1
        ;;
esac

echo ""
echo "aide管理外（ユーザー独自・保持対象）:"
report_user_skills
echo ""
green "完了"
