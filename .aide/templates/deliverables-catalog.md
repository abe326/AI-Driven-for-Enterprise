# 成果物カタログ

> セグメント×フェーズごとの成果物セットと、各成果物のテンプレート（章立て）を定義するマニフェスト。
> スキルはこれを読み、**選択式**で成果物を提示する（「既定」=初期選択）。利用者は成果物を増減できる。
> 会社/プロジェクトで調整する場合は `.aide-templates/deliverables-catalog.md`（プロジェクト直下・`.aide/` の外）に同じ表を置いて上書きする（このファイルは編集しない）。
> テンプレートパスは `.aide/templates/deliverables/<file>` 配下。`.aide-templates/deliverables/<file>` に同名があればそちらが優先される。
> 提出用の変換テンプレート（スライドテーマ・見積・スケジュール・ディスカッション・汎用ドキュメント）は本カタログの対象外で、`.aide/templates/export/` 配下の対象物フォルダに持つ。こちらも `.aide-templates/export/` で追加/優先される（スライドテーマは和集合で「追加」。詳細は [rules.md §成果物カタログ](../rules.md#成果物カタログ) の export 系項目）。

## PM業務（pm）

| フェーズ | 成果物 | テンプレート | 既定 |
|---|---|---|---|
| 憲章 | プロジェクト憲章（KPI・ゴール） | deliverables/pm-charter.md | ✓ |
| スケジュール | スケジュール表（マイルストーン・WBS） | deliverables/pm-schedule.md | ✓ |
| 課題 | 課題管理表 | deliverables/issues.md | ✓ |
| メンバ管理 | 体制図・メンバ一覧 | deliverables/pm-members.md | ✓ |

## 製品運用（product）

| フェーズ | 成果物 | テンプレート | 既定 |
|---|---|---|---|
| 課題管理 | 課題管理表 | deliverables/issues.md | ✓ |
| 設定作業記録 | 設定作業記録 | deliverables/product-setting-log.md | ✓ |
| 設定作業記録 | 手順書 | deliverables/product-procedure.md |  |

## 新規開発（dev）

| フェーズ | 成果物 | テンプレート | 既定 |
|---|---|---|---|
| 要件 | 要件書 | deliverables/requirements.md | ✓ |
| 要件 | 業務フロー | deliverables/business-flow.md |  |
| 基本設計 | 基本設計書 | deliverables/basic-design.md | ✓ |
| 基本設計 | 画面一覧 | deliverables/screen-list.md |  |
| 基本設計 | ER図 | deliverables/er-diagram.md |  |
| 基本設計 | API一覧 | deliverables/api-list.md |  |
| 詳細設計 | 詳細設計書 | deliverables/detail-design.md | ✓ |
| 実装計画 | 製造計画書（タスク分解・工数・順序） | deliverables/plans.md | ✓ |
| 単体テスト | 単体テスト仕様書 | deliverables/test-unit-spec.md | ✓ |
| 単体テスト | 単体テスト結果 | deliverables/test-unit-result.md | ✓ |
| 結合テスト | 結合テスト仕様書 | deliverables/test-integration-spec.md | ✓ |
| 結合テスト | 結合テスト結果 | deliverables/test-integration-result.md | ✓ |
| システムテスト | システムテスト仕様書 | deliverables/test-system-spec.md |  |
| システムテスト | システムテスト結果 | deliverables/test-system-result.md |  |
| 運用テスト | 運用テスト仕様書 | deliverables/test-operation-spec.md |  |
| 運用テスト | 運用テスト結果 | deliverables/test-operation-result.md |  |

## 既存運用（ops）

| フェーズ | 成果物 | テンプレート | 既定 |
|---|---|---|---|
| 問い合わせ対応 | 問い合わせ記録 | deliverables/ops-inquiry.md | ✓ |
| 課題対応 | 課題記録 | deliverables/ops-issue.md | ✓ |
| 課題対応 | 調査レポート | deliverables/ops-investigation.md |  |
| 課題対応 | 修正記録 | deliverables/ops-fix.md |  |
| 障害対応 | 障害報告書 | deliverables/ops-incident.md | ✓ |
| 障害対応 | 原因分析 | deliverables/ops-rca.md |  |
| 障害対応 | 再発防止策 | deliverables/ops-prevention.md |  |
| 開発資料・ソース格納 | （格納のみ・成果物なし） | — |  |
