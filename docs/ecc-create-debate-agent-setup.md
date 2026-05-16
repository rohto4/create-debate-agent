# ECC Setup Memo for create-debate-agent

作成日: 2026-05-15

## PJ 前提

- 日本語で対応する
- UTF-8 で読み書きする
- ECC 導入前提で対応する
- ただし、`AGENTS.md` と `PROJECT.md` は ECC 側の一般ルールより優先する

## コピー元

- ECC: `G:\devwork\clone-dir\everything-claude-code`
- ecc-expand: `G:\devwork\clone-dir\ecc-expand`

## 取り込み済みskill

討論エージェント製作PJに必要なskillを選定し、`.agents/skills/` にコピー済み。

- `api-design`: エージェント間API設計、インターフェース定義時に使う。
- `backend-patterns`: エージェントサービス層、外部連携の実装パターン。
- `coding-standards`: コード品質基準、命名規則。
- `council`: 複数視点での意思決定パターン。討論エージェント設計の中核的参考。
- `deep-research`: 討論トピックの事前調査、複数ソースからの深い調査。
- `documentation-lookup`: ライブラリ/API仕様確認。
- `product-capability`: 討論エージェント要件を実装可能な制約へ落とす。
- `research-ops`: 調査ワークフローの入口。
- `security-review`: APIキー、外部API連携の安全確認。
- `tdd-workflow`: テスト駆動開発のワークフロー。
- `verification-loop`: 実装後のbuild/test/typecheck確認。

## 取り込み済みcommand

`ecc-expand` 経由で必要なcommandを `commands/` にコピー済み。

- `commands/expand-answer.md`: 短い一次回答を必要時に詳しく展開する。
- `commands/prp-plan.md`: 実装候補を詳細な計画ファイルに落とす。
- `commands/prp-implement.md`: 計画ファイルを段階的に実行する。
- `commands/prp-prd.md`: 大きめの要望をPRD/phaseに分解する。

## 選定理由

このPJは「エージェント同士を討論させて設計書の品質を向上させる」ためのエージェント製作PJ。

標準skillに加えて以下を追加:

- `council`: 討論パターンの設計参考として最重要。複数視点での構造化された意見対立の仕組みが、討論エージェントの設計に直接関連する。
- `deep-research`: 討論トピックや設計判断の根拠となる調査に使う。
- `research-ops`: 調査ワークフローの入口として、討論前の情報収集に使う。

## 未導入

- ECCのhooks
- `.codex/config.toml`
- ツール別の大規模設定
- 現時点の運用に不要なskill/command一式

## 今後の追加候補

- `knowledge-ops`: 討論結果の永続化や知識整理が必要になった場合。
- `architecture-decision-records`: 討論で出た設計判断を正式に記録する場合。
