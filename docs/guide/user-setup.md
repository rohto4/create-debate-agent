# MoChat ユーザーセットアップガイド

更新日: 2026-05-24

## 位置づけ

- 実施タスクの正本: `docs/imp/task-lists.md`
- 本書の役割: API 実行例、パラメータ確認、トラブルシュート

## 事前確認

- MoChat アカウントを作成済み
- Chutes API キーを取得済み
- secret は `config/local/` または環境変数で管理

## API 実行例（最小）

### 1) エージェント登録

```bash
curl -X POST https://mochat.io/api/claw/agents/selfRegister \
  -H "Content-Type: application/json" \
  -d '{"name": "スキラー", "description": "技術最適化と堅牢性の観点で討論する。"}'
```

### 2) オーナー紐付け

```bash
curl -X POST https://mochat.io/api/claw/agents/bind \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "email": "your-email@example.com",
    "greeting_msg": "スキラーです。技術観点を担当します。"
  }'
```

### 3) セッション作成

```bash
curl -X POST https://mochat.io/api/claw/sessions/create \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "metadata": {"topic": "設計レビュー討論"},
    "participants": [
      {"type": "agent", "id": "skiller_bot_id"},
      {"type": "agent", "id": "hawk_bot_id"},
      {"type": "agent", "id": "keeper_bot_id"},
      {"type": "agent", "id": "mediator_bot_id"}
    ]
  }'
```

### 4) 設計書レビュー依頼を送信

```bash
curl -X POST https://mochat.io/api/claw/sessions/send \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "sessionId": "session_id_here",
    "content": "この設計書をレビューしてください: docs/spec/system-overview.md"
  }'
```

## API 一覧（主要）

- `POST /api/claw/agents/selfRegister`
- `POST /api/claw/agents/bind`
- `POST /api/claw/agents/rotateToken`
- `POST /api/claw/sessions/create`
- `POST /api/claw/sessions/send`
- `POST /api/claw/sessions/messages`

## 実施済み項目の修正方針

- リポジトリ配下で secret を扱う場合は `config/local/` 固定 + `.gitignore` 除外を維持する
- 以前配置したトークンは `rotateToken` で再発行する
- 内部命名は `mediator` に統一し、表示名は「メドラー」を使う

## トラブルシュート

- 応答なし: `X-Claw-Token` の有効期限と `bind` 状態を確認
- 送信失敗: `sessionId` と participants を確認
- 思考モード不一致: Chutes 側モデル ID と `thinking` オプションを再確認
