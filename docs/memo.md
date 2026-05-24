# 一時メモ

このファイルは一時メモ用です。確定した事項は適切なフォルダへ移してください。

---

## 2026-05-24 統合・修正サマリ（一次）

### 実施内容

- `docs/imp/task-lists.md` を MoChat 討論運用の正本として再作成した。
- `docs/guide/user-setup.md` は重複手順を削り、API 実行例とトラブルシュート中心の補助ガイドに再構成した。
- 「実施済みだが修正が必要な項目」を `task-lists.md` に明記した。

### 修正が必要と判断した点

- 過去にリポジトリ配下に secret が置かれたため、MoChat トークンの再発行（`rotateToken`）が必要。
- internal 名称の揺れ（`medler`/`mediator`）は `mediator` に統一するのが妥当。
- 実行手順が `guide/user-setup.md` と `imp/task-lists.md` に分散していたため、タスク管理の正本を `task-lists.md` に一本化。

### 反映先

- `docs/imp/task-lists.md`
- `docs/guide/user-setup.md`

---

## 2026-05-24 キー配置テンプレート（空欄）

今後のキー管理用に、実値なしテンプレートを追加。

- Chutes/Xiaomi（環境変数）:
  - `G:/devwork/create-debate-agent/.env.local.example`
- MoChat（エージェント固有 token/botUserId）:
  - `G:/devwork/create-debate-agent/config/local/skiller-credentials.example.json`
  - `G:/devwork/create-debate-agent/config/local/hawk-credentials.example.json`
  - `G:/devwork/create-debate-agent/config/local/keeper-credentials.example.json`
  - `G:/devwork/create-debate-agent/config/local/mediator-credentials.example.json`

実運用時は `.example` を外したローカル実ファイルを作って使う。

---

## 2026-05-24 MoChat 実行テストログ

- `sessions/create` 実行済み
  - `sessionId`: `session_6a12dd5da51f00f7d0789db5`
  - 保存先: `config/local/raw/session-create-test.json`
- `sessions/send` 実行済み
  - 保存先: `config/local/raw/session-send-test.json`
- `sessions/messages` 取得済み
  - `MESSAGE_COUNT=2`
  - 保存先: `config/local/raw/session-messages-test.json`

---

## 2026-05-24 追加実行ログ（順次対応）

- 4エージェントを UTF-8 固定送信で再登録・bind 済み
- `rotateToken` 実行は全エージェントで失敗
  - 返却: `500`
  - エラー: `CLAW_ADMIN_TOKEN is not set for agent registration`
  - 保存先: `config/local/raw/rotate-token-result.json`
- 討論セッション作成と初回投稿を実行
  - `sessionId`: `session_6a12df844a7f96ef70fa5189`
  - `MESSAGE_COUNT=2`（1ラウンド完走までは未到達）
  - 保存先:
    - `config/local/raw/debate-session-create.json`
    - `config/local/raw/debate-session-send.json`
    - `config/local/raw/debate-session-messages.json`

---

## 2026-05-24 討論対象指定ルールの正本化

- 討論対象指定（manifest方式、全文非アップロード、版固定）の正本を以下に集約:
  - `docs/spec/debate-targeting-rule.md`
- 今後、対象指定ルールの追記・修正はこの1ファイルのみを更新する。
