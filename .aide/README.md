# aide（AI Driven for Enterprise）利用ガイド

> IDE/コンソールを扱える層が、AIと伴走して業務を進めるための Enterprise 向けフレームワーク。
> Claude Code / GitHub Copilot / Codex 共通。

## 2つの利用モード

| モード | 起動 | 何が起きるか |
|---|---|---|
| **自由モード** | init 不要 | 指示が曖昧なら一度ブレスト提案、作業フォルダ未設定なら確認、意図が固まれば適切なスキルを提案し承認を得て実行（いきなり実行しない）（`aide-advisor`） |
| **伴走モード** | `aide-init` 済み | セグメントに沿った伴走タスクを生成し、先走り/出戻りを検知（`aide-journey`）。選んだフェーズだけ浅いフォルダを生成 |

## セグメント（4区分・1軸）

| セグメント | 識別子 | 主目的 |
|---|---|---|
| PM業務 | `pm` | KPI/ゴール設定・プロジェクト管理 |
| 製品運用 | `product` | 製品の設定作業・問題解決（コードを書かない運用） |
| 新規開発 | `dev` | ウォーターフォール×SDD のAI駆動開発 |
| 既存運用 | `ops` | 問い合わせ・課題・障害対応 |

Enterprise 向けは全セグメント共通。監査・トレーサビリティは選択式オプション。

## クイックスタート

```bash
# 初期化（セグメント・作業フォルダ・フェーズ・成果物を選択式で確定）
/aide-init                 # 対話でセグメントを選ぶ（pm / product / dev / ops、複数可）

# 迷ったら、指定なしで指示を出すだけ（自由モード）
# 例:「この障害ファイルの対応を検討して」→ aide-advisor が適切なスキルを提案し承認を得て実行
```

## 利用ケース別ガイド

### A. PM業務（`pm`）
```
憲章(KPI/ゴール) → スケジュール/課題/メンバ管理 → 定期レビュー・振り返り
```
`aide-pm-charter` → `aide-pm-manage` →（`aide-pm-meeting` / `aide-pm-estimate` / `aide-pm-slide` / `aide-pm-retro`）

### B. 製品運用（`product`）
```
課題受付 → バージョン指定で公式情報検索・解決 → 設定作業を記録
```
`aide-product-task`（課題管理）/ `aide-product-resolve`（製品バージョン指定→WEB検索→解決策）

### C. 新規開発（`dev`）— ハーネスエンジニアリング
```
要件 → 基本設計 → 詳細設計/実装計画 → 実装 → 単体 → 結合 → システム → 運用テスト
```
`aide-dev-spec`（前フェーズ準拠チェック）→ `aide-dev-code`（承認ゲート＋Spec-Anchored）→ `aide-dev-testspec` → `aide-dev-test`。各フェーズ完了時に **V字対応のペルソナレビュー**（`aide-review`）。

### D. 既存運用（`ops`）
```
受付（問い合わせ/課題/障害）→ 調査 → 修正 → クローズ
```
`aide-ops-inquiry` / `aide-ops-issue` / `aide-ops-incident` → `aide-ops-investigate` → `aide-ops-fix` → `aide-ops-close`。
作業フォルダにファイルを置いて「対応を検討して」と言えば、アドバイザーが拾って起票・調査につなぐ。

## コマンド一覧（早見表）

### コア共通
| コマンド | 説明 |
|---|---|
| `aide-init` | セグメント選択・作業フォルダ確認・選択式フォルダ生成・プロファイル生成 |
| `aide-advisor` | 自由モードの入口。現在地分析・確認の上、適切なスキルを提案し承認を得て実行 |
| `aide-brainstorm` | ブレストで成果物を作成・更新（カタログ連動） |
| `aide-sync` | 会話内容の反映計画→OKゲート→ドキュメント反映 |
| `aide-journey` | 伴走タスク生成・現在地提示・先走り/出戻り検知 |
| `aide-review` | ペルソナ別レビューエージェントを起動 |
| `aide-diagram` | draw.io互換SVG図を生成 |
| `aide-export` | 成果物をHTML/PDF/docx/pptxへ変換 |

### セグメント別
| セグメント | コマンド |
|---|---|
| pm | `aide-pm-charter` / `aide-pm-manage` / `aide-pm-meeting` / `aide-pm-estimate` / `aide-pm-slide` / `aide-pm-retro` |
| product | `aide-product-resolve` / `aide-product-task` |
| dev | `aide-dev-spec` / `aide-dev-code` / `aide-dev-testspec` / `aide-dev-test` / `aide-dev-migrate` |
| ops | `aide-ops-inquiry` / `aide-ops-issue` / `aide-ops-incident` / `aide-ops-investigate` / `aide-ops-fix` / `aide-ops-close` |

## レビューペルソナ（`.aide/agents/`）

作業完了時に独立コンテキストでレビューする。新規開発はV字で対応フェーズと照合。

| ペルソナ | 対象 | V字対応 |
|---|---|---|
| `requirements-reviewer` | 要件書 | ⇔運用テスト |
| `basic-design-reviewer` | 基本設計書 | ⇔結合・システムテスト |
| `detail-design-reviewer` | 詳細設計/製造計画 | ⇔単体テスト |
| `code-reviewer` / `security-reviewer` | 実装コード | — |
| `document-reviewer` / `source-reviewer` | 既存運用のドキュメント/ソース | — |
| `pm-reviewer` | PM成果物 | — |
| `product-setting-reviewer` | 製品設定作業 | — |

## 成果物カタログとカスタマイズ

**`.aide/` はフレームワーク核として一切編集しない（不可侵）。** カスタマイズは `.aide/` の外で行う。

- **成果物カタログ** `.aide/templates/deliverables-catalog.md` … セグメント×フェーズ→成果物セット＋雛形を定義。`aide-init` が選択式で提示（既定マーク付き）し、増減可能。選択はプロファイルに記録
- **章立て雛形** `.aide/templates/deliverables/<name>.md`
- **Rules のカスタム** … `CLAUDE.md` / `AGENTS.md` に直接記述（共通 `.aide/rules.md` は編集しない）
- **Skills / レビューエージェントのカスタム** … 独自スキルは `.claude/skills/`・`.agents/skills/`、独自エージェントは `.claude/agents/` に直接作成。sync は aide 管理外のものを消さない・上書きしない。既存 `aide-*` の上書きは非対応（別名で追加）
- **Templates のカスタム** … `.aide-templates/`（プロジェクト直下・`.aide/` の外）にカタログ・雛形の上書きを置く。`aide-init` が「標準メニューを調整しますか？」に Yes で `.aide-templates/` を自動生成
- カタログ・雛形は実行時読み込み＝**編集即反映、`sync` 再実行不要**

### 3大原則
1. **Human-in-the-Loop** — ハーネスエンジニアリングの大原則。AIへのフィードフォワード（インプットの精度）とフィードバック（アウトプットの仕様照合）を人間が検査。実装前の承認ゲートと完了時のペルソナレビューで体現
2. **SSoT** — SDD と Spec-Anchored で仕様書を常に最新化し、人もAIもドキュメントを正として対話・判断
3. **伴走性** — 指定がなくても確認/ブレストを挟み、意図が固まれば適切なスキルを提案し承認を得て実行

> SSoT が HITL のフィードフォワードを支え、HITL のフィードバックが SSoT を最新化し、伴走性が循環を日々の対話に接続する。

### 運用ルール（作法）
選択式・オンデマンド生成／浅い階層・中身は自由／勝手に作らない・作業フォルダ外に出さない／インデックス駆動の読み込み

詳細は `.aide/rules.md` を参照。

## フォルダ構成（2系統に集約）

スキル正本を `.aide/skills/`、レビューエージェント正本を `.aide/agents/` に一元管理し、ラッパーを自動生成する。

```
project-root/
├── .aide/                           # フレームワーク核（不可侵・一切編集しない）
│   ├── rules.md                     # 共通ルール（Single Source of Truth）
│   ├── skills/                      # ★ スキル正本（27）
│   ├── agents/                      # ★ レビューエージェント正本（9）
│   ├── templates/
│   │   ├── deliverables-catalog.md  # 成果物カタログ（マニフェスト）
│   │   ├── deliverables/            # 成果物の章立て雛形
│   │   └── export/                  # 変換テンプレート
│   └── scripts/
│       ├── sync-skills.sh           # ラッパー生成（bash）
│       └── sync-skills.ps1          # ラッパー生成（PowerShell / Windows）
│
├── .aide-templates/                 # ◆カスタム: カタログ/雛形の上書き（任意・.aide の外）
├── CLAUDE.md                        # Claude Code用 → @.aide/rules.md ＋ aideプロファイル（◆Rules カスタム）
├── AGENTS.md                        # Copilot / Codex用 → .aide/rules.md 参照（◆Rules カスタム）
│
├── .claude/skills/                  # ラッパー（自動生成）＋ ◆独自スキル
├── .claude/agents/                  # レビューエージェント（自動生成）＋ ◆独自エージェント
└── .agents/skills/                  # Copilot + Codex 用ラッパー（自動生成）＋ ◆独自スキル
```

> ルールファイルは **CLAUDE.md と AGENTS.md の2本のみ**、スキルラッパーは **`.claude/skills/` と `.agents/skills/` の2系統のみ**。
> `.github/copilot-instructions.md` / `.github/skills/` / `.github/prompts/` は使用しない（Copilot は AGENTS.md + `.agents/skills/` を解釈）。

### スキル・エージェントの保守

正本（`.aide/skills/`・`.aide/agents/`）のみ編集し、ラッパーは sync で再生成する。

```bash
# POSIX（bash）
bash .aide/scripts/sync-skills.sh           # 全ツール
bash .aide/scripts/sync-skills.sh claude    # Claude Code のみ
bash .aide/scripts/sync-skills.sh agents    # Copilot + Codex のみ
```
```powershell
# Windows（PowerShell・WSL2不要）
pwsh -File .aide/scripts/sync-skills.ps1
```

## 動作環境

| 環境 | 対応 | 備考 |
|---|---|---|
| WSL2 / macOS / Linux | 推奨 | bash 版 sync |
| **Windows 11 / PowerShell** | **対応（WSL2不要）** | PowerShell 版 sync（`sync-skills.ps1`）。Python は `python`/`py` |
| Git Bash（Windows） | 対応 | bash 版 sync |

> フォルダ名に日本語を含むため、ターミナルのロケールは UTF-8 を推奨。
> AIが実行するコマンドは OS で読み替える（`python3`⇔`python`/`py`、`bash`⇔`pwsh`）。詳細は rules.md「クロスプラットフォーム」。

### 必須・任意ツール

- aide 自体の必須は **Git のみ**。PM系・開発系の多くは外部ツール不要
- **エクスポート**: marked / marp-cli / pandoc / ansi2html / Playwright（用途に応じ案内）
- **Office読み込み**: pandoc / python-pptx / openpyxl / python-docx（`.aide/templates/export/scripts/`、OS別コマンド）
- **VS Code 拡張**: Marp for VS Code（スライドのプレビュー）

## 設計思想（資料生成 `aide-pm-slide`）

スライド生成は学術的に実証された3層構成を採用：
```
第1層: SCQ（全体ストーリー） → 第2層: ピラミッド原則（セクション） → 第3層: 1スライド1メッセージ
```

| フレームワーク | 出自 | 役割 |
|---|---|---|
| SCQ | Barbara Minto, McKinsey | ストーリーライン（Situation→Complication→Question→Answer） |
| ピラミッド原則 | Barbara Minto | 結論→根拠→詳細 |
| CRAP原則 | Robin Williams (1994) | 視覚設計（Contrast/Repetition/Alignment/Proximity） |
| Miller's Law / 認知負荷理論 | Miller(1956) / Sweller(1988) | 1スライドの情報量制御 |

コンテンツ品質は So What?／数字／固有名詞／行動 テストで担保。情報不足時は薄く埋めず、必要データをユーザーに確認する。
