# AGENTS.md

このプロジェクトはaideフレームワークを使用しています。

**セッション開始時に `.aide/rules.md` を必ず読み、その内容に従ってください。**

- `.aide/rules.md`: aide共通ルール（原則・コーディング規約・コマンド一覧）
- `.aide/skills/`: aideスキル定義の正本（Single Source of Truth）
- `.aide/agents/`: ペルソナ別レビューエージェント定義の正本
- `CLAUDE.md`: プロジェクト固有の設定（プロファイル・概要・フェーズ・技術スタック・制約）
- 各AIツール用ラッパー（`.aide/` の正本を参照）:
  - `.claude/skills/`: Claude Code 用（Agent Skills形式）
  - `.agents/skills/`: GitHub Copilot + Codex CLI 用（横断オープン標準）

> このファイル（AGENTS.md）は Copilot + Codex 共用の命令ファイルです。
> ルールファイルは CLAUDE.md と AGENTS.md の2本のみです。

> **注意: このファイルの上記の内容は編集しないでください。**
> `.aide/rules.md` の読み込み指示はaideフレームワークの動作に必要です。

---

<!-- ここから下にプロジェクト固有のルールを記載してください。 -->
