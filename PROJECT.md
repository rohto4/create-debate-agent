# create-debate-agent Project Context

## 目的

チャット上でエージェント同士を討論させて設計書の品質を向上させるための討論用エージェントを製作する。

## PJ固有方針

- 討論の質を最優先し、複数視点からの検討を構造化する。
- エージェント間の討論は透明性があり、追跡可能にする。
- 設計書の品質向上を目的とし、討論は手段として最適化する。
- 討論の結果は設計書に反映可能な形式で整理する。

## 主な機能・成果物

- 討論エージェントのアーキテクチャ設計
- エージェント間の討論プロトコル定義
- 討論の質を評価する基準と検証方法
- 設計書品質の向上手法
- 実装、テスト、運用に関する仕様とメモ

## 優先度モデル

1. `AGENTS.md`: agent共通の最上位ルール
2. `PROJECT.md`: PJ固有の目的、構成、運用方針
3. `docs/guide/`: 採用済みガイド、判断基準
4. `docs/spec/`: 確定仕様、要件、設計前提
5. `docs/candi-ref/`: 候補、調査、比較、未採用案
6. `docs/imp/`: 作業計画、実装メモ、完了記録
7. `docs/diary/`: セッション記録
8. `docs/setting/`: 初期化とテンプレート
9. `.agents/skills/`: 必要時に読むECC由来skill
10. `commands/`: 必要時に読むECC/ecc-expand由来command

## ECCコピー元

- ECC: `G:\devwork\clone-dir\everything-claude-code`
- ecc-expand: `G:\devwork\clone-dir\ecc-expand`

## 取り込み対象skill

- `api-design`: API設計、エラー設計、インターフェース定義
- `backend-patterns`: サービス層、外部API連携などの実装パターン
- `coding-standards`: コード品質基準、命名規則
- `council`: 複数視点での意思決定、討論パターン
- `deep-research`: 複数ソースからの深い調査
- `documentation-lookup`: ライブラリ/API仕様確認
- `product-capability`: 要件を実装可能な制約へ落とす
- `research-ops`: 調査ワークフローの入口
- `security-review`: secret、認証、外部APIの安全確認
- `tdd-workflow`: テスト駆動開発のワークフロー
- `verification-loop`: 実装後のbuild/test/typecheck確認

## 取り込み対象command

- `expand-answer.md`: 短い一次回答を必要時に詳しく展開する
- `prp-plan.md`: 実装候補を詳細な計画ファイルに落とす
- `prp-implement.md`: 計画ファイルを段階的に実行する
- `prp-prd.md`: 大きめの要望をPRD/phaseに分解する

## 運用ルール

- 採用済みルールは `docs/guide/` または `docs/spec/` に移す。
- 未確定の案、比較、調査は `docs/candi-ref/` に置く。
- 一時メモは `docs/memo.md` に置いてよいが、確定したら適切な場所へ移す。
- PJ固有の重要な決定は、可能な限り理由も残す。
- 外部サービスの最新仕様や規約に依存する内容は、必要時に公式情報を確認する。
