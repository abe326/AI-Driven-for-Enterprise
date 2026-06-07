---
name: aide-export
description: 既存の成果物（要件書・設計書・製造計画書など）を HTML・PDF・docx・pptx 形式に変換し、提出用ドキュメントを生成する。「提出用ファイルを作りたい」「PDFに変換して」「Word形式にしたい」「HTML版を作って」と言われたら使う。新規のスライド・報告書・見積書を作る場合は aide-pm-slide を使う。
short_description: 成果物（要件書・設計書等）を HTML / PDF / docx に一括変換する
---

# aide-export: 成果物エクスポート

成果物を提出用形式に変換する。**基本フロー: md → HTML →（PDF / docx / pptx）**。HTML を中間形式として必ず生成する（HTML-First）。

## テンプレート（`.aide/templates/export/`・対象物ごとフォルダ）

各テンプレートは `.aide/templates/export/<対象物>/` を正本とし、**`.aide-templates/export/<同じ相対パス>` に同名があればそちらを優先**する（`.aide/templates/export/` → `.aide-templates/export/`、[rules.md §成果物カタログ](../../rules.md#成果物カタログ)）。`.aide/` 本体は編集しない。

| フォルダ / ファイル | 用途 |
|---|---|
| `document/document-template.html` / `document-style.css` | 提出用ドキュメント |
| `estimate/estimate-template.html` | 見積書 |
| `schedule/schedule-template.html` | スケジュール表（ガント） |
| `discussion/discussion-template.html` | ディスカッション資料 |
| `slide/slide-template.md` / `slide/themes/<name>/theme.css` | スライド（雛形＋テーマ） |
| `metadata.yaml` / `scripts/` | 共通（メタデータ・変換スクリプト） |

**スライドのテーマ解決**: 変換対象 MD の frontmatter `theme:` 名を読み、同名テーマフォルダの `theme.css` を二段解決で探す（フォルダ名＝`@theme` 名＝`theme:` 値）。
- **HTML/PDF 経路（Marp CLI）**: 全テーマの CSS を `--theme-set` で登録してから `theme:` で解決させる。`.aide-templates/` 側を後に並べる（CLI は後勝ち＝案件カスタム優先）:
  ```bash
  marp slide.md \
    --theme-set .aide/templates/export/slide/themes/*/theme.css \
                .aide-templates/export/slide/themes/*/theme.css \
    -o slide.html        # PDF は --pdf
  ```
- **PPTX 経路**: `md2pptx.py` が frontmatter の `theme:` から自動解決し、`theme.css` の `:root` をパースして同じ配色を適用する（`--theme <name>` で明示も可）:
  ```bash
  python3 .aide/templates/export/scripts/md2pptx.py slide.md -o slide.pptx
  ```
- frontmatter に `theme:` が無ければ既定 `corporate`。旧名 `aide-corporate` は `corporate` のエイリアスとして解決される。

## 手順

### 1. 対象の特定
プロファイルの作業フォルダから、変換対象の成果物を特定する。種別（ドキュメント／見積書／スケジュール／ディスカッション／スライド）に応じてテンプレートを選ぶ。

### 2. 変換（OS対応）
- md → HTML（テンプレート適用）
- HTML → PDF / docx / pptx（pandoc 等）。**コマンドは OS で読み替える**（[クロスプラットフォーム](../../rules.md#クロスプラットフォーム)：`python3`⇔`python`/`py`）
- 図（`.drawio.svg`）は埋め込み or 添付

### 3. 出力と確認
変換物を作業フォルダの該当フェーズ（または `export/`）に出力し、生成物一覧を報告する。フェーズ完了を待たずいつでも実行可能。

## 注意事項
- 正本は md。変換物は提出用の派生（正本と矛盾させない）
- 必要ツール（pandoc 等）が未導入なら導入を案内（OS別コマンド）
