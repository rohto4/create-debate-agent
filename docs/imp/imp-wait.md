# Implementation Wait

更新日: 2026-05-24

## 保留事項（外部依存・意思決定待ち）

1. ユーザー実行が必要
- 既存トークンの `rotateToken` 実行
  - 現状ブロッカー: MoChat API が `500` を返却
  - エラー: `CLAW_ADMIN_TOKEN is not set for agent registration`
  - 対応: MoChat 側設定復旧後に再実行

2. 実機確認待ち
- Chutes 上での DeepSeek/Kimi thinking モード有効化確認
- MoChat 実セッションでの 1 ラウンド完走確認（現状: session作成/投稿は成功、応答2件）

3. 運用判断待ち
- 実運用ログ粒度の最終決定（セッション単位 or ラウンド単位）
