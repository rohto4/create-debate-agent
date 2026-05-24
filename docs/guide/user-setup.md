# MoChat 動作セットアップ手順

作成日: 2026-05-15

## 概要

討論エージェント（スキラー、ホーク、キーパー、メドラー）を MoChat（mochat.io）上で動作させるための手順。

---

## 1. 前提条件

- MoChat アカウント（mochat.io でメール登録）
- Chutes API キー（MiMo-V2.5-Pro、DeepSeek V3.2、Kimi K2.5 TEE 用）
- Python 3.12+
- インターネット接続

---

## 2. MoChat アカウント登録

1. https://mochat.io にアクセス
2. メールアドレスでアカウント登録
3. ログインしてダッシュボードにアクセス

---

## 3. エージェント登録

各エージェント（スキラー、ホーク、キーパー、メドラー）を MoChat に登録する。

### 3.1 selfRegister API の呼び出し

各エージェントごとに1回ずつ実行する:

**Windows/MINGW64 の場合**: 日本語の文字エンコーディングでエラーが出ることがある。その場合はJSONをファイルに書いてから `-d @file` で送信する:

```bash
# 例: メドラー登録用JSONファイルを作成
cat > /tmp/medler-register.json << 'EOF'
{"name": "メドラー", "description": "討論を取りまとめ、合意形成を促す。各エージェントの意見を構造化し、合意点と対立点を明確にする。最大ラウンド数までに判断を出し、必要なら人間に委ねる。"}
EOF

# ファイルから読み込んで送信
curl -X POST https://mochat.io/api/claw/agents/selfRegister \
  -H "Content-Type: application/json" \
  -d @/tmp/medler-register.json
```

**Linux/macOS の場合**: そのまま実行可能:

```bash
# スキラー
curl -X POST https://mochat.io/api/claw/agents/selfRegister \
  -H "Content-Type: application/json" \
  -d '{"name": "スキラー", "description": "技術的な最適解を追求する。パフォーマンス、保守性、拡張性の観点から設計を検証し、スケールしない設計や技術的負債を許容しない。具体的なコードやアーキテクチャ案を提示する。"}'

# ホーク
curl -X POST https://mochat.io/api/claw/agents/selfRegister \
  -H "Content-Type: application/json" \
  -d '{"name": "ホーク", "description": "ユーザの立場で物事を考える。要件の抜け漏れを指摘し、操作の直感性やエラーメッセージの分かりやすさを重視する。過度な技術的要求より、体験の良さを優先する。"}'

# キーパー
curl -X POST https://mochat.io/api/claw/agents/selfRegister \
  -H "Content-Type: application/json" \
  -d '{"name": "キーパー", "description": "最後の砦として設計を守る。認証、認可、データ保護の観点に加え、法的リスクとコストの妥当性を検証する。この設計で事故ったらどうなるかを問う。"}'

# メドラー
curl -X POST https://mochat.io/api/claw/agents/selfRegister \
  -H "Content-Type: application/json" \
  -d '{"name": "メドラー", "description": "討論を取りまとめ、合意形成を促す。各エージェントの意見を構造化し、合意点と対立点を明確にする。最大ラウンド数までに判断を出し、必要なら人間に委ねる。"}'
```

### 3.2 認証情報の保存

各エージェントの `selfRegister` レスポンスから `token` と `botUserId` を保存する:

```bash
mkdir -p ~/.config/mochat

# 例: スキラーの認証情報
cat > ~/.config/mochat/skiller-credentials.json << 'EOF'
{
  "token": "claw_xxxxxxxxxxxx",
  "botUserId": "67890abcdef"
}
EOF

# 同様に hawk-credentials.json, keeper-credentials.json, medler-credentials.json を作成
```

### 3.3 オーナーとの紐付け

各エージェントをオーナー（あなた）のメールアドレスに紐付ける:

```bash
# スキラー
curl -X POST https://mochat.io/api/claw/agents/bind \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "email": "your-email@example.com",
    "greeting_msg": "スキラーです。技術的な最適解を追求します。パフォーマンス、保守性、拡張性の観点から設計を検証し、具体的なコードやアーキテクチャ案を提示します。"
  }'

# ホーク
curl -X POST https://mochat.io/api/claw/agents/bind \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "email": "your-email@example.com",
    "greeting_msg": "ホークです。ユーザの立場で物事を考えます。要件の抜け漏れを指摘し、操作の直感性やエラーメッセージの分かりやすさを重視します。"
  }'

# キーパー
curl -X POST https://mochat.io/api/claw/agents/bind \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "email": "your-email@example.com",
    "greeting_msg": "キーパーです。最後の砦として設計を守ります。認証、認可、データ保護に加え、法的リスクとコストの妥当性を検証します。"
  }'

# メドラー
curl -X POST https://mochat.io/api/claw/agents/bind \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "email": "your-email@example.com",
    "greeting_msg": "メドラーです。討論を取りまとめ、合意形成を促します。各エージェントの意見を構造化し、合意点と対立点を明確にします。"
  }'
```

---

## 4. アダプター選択

MoChat は複数のアダプターをサポートしている:

| アダプター | 特徴 | 推奨度 |
|---|---|---|
| **Nanobot** | 自動セットアップ対応。Socket.IO WebSocket | ★★★★★ |
| **OpenClaw** | プラグインシステム。設定が豊富 | ★★★★ |
| **Claude Code** | Claude Code プロジェクト向け | ★★★ |
| **自前実装** | MoChat API を直接呼び出し | ★★★★ |

このPJでは、討論プロトコルを自前で実装するため、**MoChat API を直接呼び出す方式**が最適。

---

## 5. 自前実装アーキテクチャ

### 5.1 プロジェクト構成

```
create-debate-agent/
├── src/
│   ├── agents/
│   │   ├── skiller.py      # スキラー（MiMo-V2.5-Pro）
│   │   ├── hawk.py         # ホーク（DeepSeek V3.2 thinking）
│   │   ├── keeper.py       # キーパー（Kimi K2.5 TEE thinking）
│   │   └── medler.py       # メドラー（MiMo-V2.5-Pro）
│   ├── mochat/
│   │   ├── client.py       # MoChat API クライアント
│   │   └── socket.py       # Socket.IO イベント受信
│   ├── debate/
│   │   ├── orchestrator.py # 討論オーケストレーター
│   │   ├── protocol.py     # 討論プロトコル（ラウンド管理）
│   │   └── convergence.py  # 収束判断ロジック
│   └── config.py           # 設定（API キー、MoChat 認証情報）
├── config/
│   └── agents.yaml         # エージェント設定
├── requirements.txt
└── main.py
```

### 5.2 主要コンポーネント

| コンポーネント | 役割 |
|---|---|
| `mochat/client.py` | MoChat API（selfRegister, bind, sessions/send 等）を呼び出す |
| `mochat/socket.py` | Socket.IO でメッセージイベントを受信する |
| `debate/orchestrator.py` | エージェントの発言順序を制御し、ラウンドを管理する |
| `debate/convergence.py` | メドラーの取りまとめ結果を判定し、合意/対立/保留を決定する |
| `agents/*.py` | 各エージェントの LLM 呼び出し（OpenAI SDK + Chutes 経由） |

---

## 6. 依存パッケージ

```txt
# requirements.txt
openai>=1.0.0
python-socketio>=5.0.0
pyyaml>=6.0
httpx>=0.24.0
```

---

## 7. 設定ファイル

```yaml
# config/agents.yaml
mochat:
  base_url: "https://mochat.io"
  socket_url: "https://mochat.io"

agents:
  skiller:
    name: "スキラー"
    model: "xiaomi/MiMo-V2.5-Pro"
    credentials_file: "~/.config/mochat/skiller-credentials.json"
    role: "技術最適化 + 堅牢性"

  hawk:
    name: "ホーク"
    model: "deepseek-ai/DeepSeek-V3.2"
    mode: "thinking"
    credentials_file: "~/.config/mochat/hawk-credentials.json"
    role: "ユーザ視点 + 要件拡充"

  keeper:
    name: "キーパー"
    model: "moonshotai/Kimi-K2.5-TEE"
    mode: "thinking"
    credentials_file: "~/.config/mochat/keeper-credentials.json"
    role: "セキュリティ + 法務 + 経理視点"

  medler:
    name: "メドラー"
    model: "xiaomi/MiMo-V2.5-Pro"
    credentials_file: "~/.config/mochat/medler-credentials.json"
    role: "取りまとめ + 合意形成"

debate:
  max_rounds: 3
  convergence_threshold: 0.8
  output_dir: "docs/debate-results"
```

---

## 8. 動作確認手順

### 8.1 MoChat セッション作成

```bash
# 討論用セッションを作成
curl -X POST https://mochat.io/api/claw/sessions/create \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "name": "設計レビュー討論",
    "participants": ["skiller_bot_id", "hawk_bot_id", "keeper_bot_id", "medler_bot_id"]
  }'
```

### 8.2 テスト送信

```bash
# セッションにメッセージを送信
curl -X POST https://mochat.io/api/claw/sessions/send \
  -H "Content-Type: application/json" \
  -H "X-Claw-Token: claw_xxxxxxxxxxxx" \
  -d '{
    "sessionId": "session_id_here",
    "content": "この設計書をレビューしてください: docs/spec/architecture.md"
  }'
```

### 8.3 エージェント応答確認

MoChat の UI で、各エージェントがスレッド内に順番に発言し、メドラーが取りまとめることを確認する。

---

## 9. MoChat API リファレンス

| エンドポイント | 方法 | 説明 |
|---|---|---|
| `/api/claw/agents/selfRegister` | POST | エージェント登録 |
| `/api/claw/agents/bind` | POST | オーナー紐付け |
| `/api/claw/agents/rotateToken` | POST | トークン更新 |
| `/api/claw/sessions/create` | POST | セッション作成 |
| `/api/claw/sessions/send` | POST | メッセージ送信 |
| `/api/claw/sessions/get` | POST | セッション情報取得 |
| `/api/claw/sessions/messages` | POST | メッセージ履歴取得 |
| `/api/claw/sessions/list` | POST | セッション一覧 |
| `/api/claw/groups/panels/create` | POST | パネル作成 |
| `/api/claw/groups/panels/send` | POST | パネルにメッセージ送信 |

認証: 全リクエストに `X-Claw-Token` ヘッダーが必要。

---

## 10. 参考リンク

| リソース | URL |
|---|---|
| MoChat 公式 | https://mochat.io |
| MoChat GitHub | https://github.com/HKUDS/MoChat |
| MoChat スキルファイル | https://mochat.io/skill.md |
| Nanobot MoChat ドキュメント | https://hkuds-nanobot-68.mintlify.app/channels/mochat |
| MoChat API リファレンス | https://mochat.io/skill.md （Platform API Reference セクション） |
| Socket.IO Python | https://python-socketio.readthedocs.io/ |
| OpenAI SDK | https://platform.openai.com/docs/api-reference |

---

## 11. トラブルシューティング

| 問題 | 対処 |
|---|---|
| エージェントが応答しない | `X-Claw-Token` が正しいか確認。`selfRegister` のレスポンスから再取得 |
| メッセージが届かない | `sessions` フィルタが `["*"]` になっているか確認 |
| Socket.IO 接続エラー | ファイアウォールで WebSocket (443) が許可されているか確認 |
| トークン切れ | `/api/claw/agents/rotateToken` でトークンを更新 |
