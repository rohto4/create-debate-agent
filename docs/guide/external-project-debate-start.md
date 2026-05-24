# 外部PJ設計書の討論開始手順

更新日: 2026-05-24

## 目的

このPJ外にある設計書（例: `../io-bot-soul/docs`）を対象に、MoChatで討論を開始する手順を定義する。

本手順は `docs/spec/debate-targeting-rule.md` に準拠する。

## 前提

- `create-debate-agent` のローカル環境で実行する
- 4エージェントの MoChat 認証情報が `config/local/*.json` にある
- `../io-bot-soul/docs` へ読み取り可能

## 手順

1. 対象ファイルを決める
- 例:
  - `../io-bot-soul/docs/architecture.md`
  - `../io-bot-soul/docs/api-spec.md`
  - `../io-bot-soul/docs/ops.md`

2. 一時 manifest を作る
- 推奨パス: `config/local/target-manifest.external.yaml`

```yaml
version: 1
root: G:/devwork
targets:
  - id: io-bot-soul-core
    paths:
      - ../io-bot-soul/docs/architecture.md
      - ../io-bot-soul/docs/api-spec.md
      - ../io-bot-soul/docs/ops.md
    focus:
      - consistency
      - feasibility
      - security
    priority: high
```

3. 討論キック文を作る

```text
討論開始。
target_id: io-bot-soul-core
paths:
- ../io-bot-soul/docs/architecture.md
- ../io-bot-soul/docs/api-spec.md
- ../io-bot-soul/docs/ops.md
focus:
- consistency
- feasibility
- security
output_format: 合意点/対立点/保留点
round_limit: 3
```

4. セッション作成と投稿
- `config/local/skiller-credentials.json` の `token` を使って `sessions/create` と `sessions/send` を実行する
- 参加者は4エージェント（skiller/hawk/keeper/mediator）の `botUserId`

5. 進行確認
- `sessions/messages` でメッセージを取得
- メドラーの `合意/対立/保留` 判定が出るまで追跡

6. 結果保存
- `docs/debate-results/YYYY-MM-DD_<topic>.md` へ保存
- テンプレート: `docs/debate-results/template.md`

## 実行コマンド例（PowerShell）

```powershell
Set-Location G:\devwork\create-debate-agent

$sk = Get-Content config/local/skiller-credentials.json -Encoding UTF8 | ConvertFrom-Json
$hk = Get-Content config/local/hawk-credentials.json -Encoding UTF8 | ConvertFrom-Json
$kp = Get-Content config/local/keeper-credentials.json -Encoding UTF8 | ConvertFrom-Json
$md = Get-Content config/local/mediator-credentials.json -Encoding UTF8 | ConvertFrom-Json

$participants = @(
  @{ type='agent'; id=$sk.botUserId },
  @{ type='agent'; id=$hk.botUserId },
  @{ type='agent'; id=$kp.botUserId },
  @{ type='agent'; id=$md.botUserId }
)

$createBody = @{
  metadata = @{ topic = 'io-bot-soul-refine' }
  participants = $participants
} | ConvertTo-Json -Depth 10

$createRes = Invoke-RestMethod -Method Post `
  -Uri 'https://mochat.io/api/claw/sessions/create' `
  -Headers @{ 'X-Claw-Token' = $sk.token } `
  -ContentType 'application/json; charset=utf-8' `
  -Body ([System.Text.Encoding]::UTF8.GetBytes($createBody))

$sessionId = $createRes.sessionId
if (-not $sessionId -and $createRes.data) { $sessionId = $createRes.data.sessionId }

$kick = @"
討論開始。
target_id: io-bot-soul-core
paths:
- ../io-bot-soul/docs/architecture.md
- ../io-bot-soul/docs/api-spec.md
- ../io-bot-soul/docs/ops.md
focus:
- consistency
- feasibility
- security
output_format: 合意点/対立点/保留点
round_limit: 3
"@

$sendBody = @{ sessionId = $sessionId; content = $kick } | ConvertTo-Json -Compress

Invoke-RestMethod -Method Post `
  -Uri 'https://mochat.io/api/claw/sessions/send' `
  -Headers @{ 'X-Claw-Token' = $sk.token } `
  -ContentType 'application/json; charset=utf-8' `
  -Body ([System.Text.Encoding]::UTF8.GetBytes($sendBody))
```

## 注意

- 外部PJ側のファイル更新中に討論を走らせない（版ずれ防止）
- 長大ファイルは `target_id` を分割して複数セッションにする
- `config/local/` の実トークン類はコミットしない
