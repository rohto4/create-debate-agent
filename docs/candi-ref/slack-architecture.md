# Slack 動作環境案

作成日: 2026-05-15

> 2026-05-24 時点では MoChat を初期チャット基盤として採用するため、この文書は候補・代替案として保持する。

## 概要

討論エージェント（スキラー、ホーク、キーパー、メドラー）を Slack 上で動作させるための技術スタック。

---

## 1. 技術スタック

### 1.1 Slack ボットフレームワーク

| コンポーネント | 技術 | 理由 |
|---|---|---|
| SDK | **Bolt for Python** | Slack 公式 SDK。Socket Mode / HTTP Mode 両対応 |
| 接続方式 | **Socket Mode** | 公開URL不要。ローカル開発・ファイアウォール内でも動作 |
| 言語 | **Python 3.12+** | OpenAI SDK、Bolt、LangGraph との互換性 |

### 1.2 LLM クライアント

| コンポーネント | 技術 | 理由 |
|---|---|---|
| LLM SDK | **OpenAI SDK (Python)** | Chutes 経由で全モデル共通 |
| API | **Chutes API** | MiMo-V2.5-Pro、DeepSeek V3.2 TEE、Kimi K2.5 TEE にアクセス |

### 1.3 オーケストレーション

| コンポーネント | 技術 | 理由 |
|---|---|---|
| 討論管理 | **自前実装** | 討論プロトコル（ラウンド管理、収束判断）に合わせて設計 |
| 状態管理 | **Slack スレッド** | 各討論をスレッドで管理。会話履歴は Slack が保持 |
| ファイル監視 | **watchfiles** | プロンプトファイル生成のトリガー検知用 |

### 1.4 Slack App 設定

| 設定 | 値 |
|---|---|
| 接続方式 | Socket Mode |
| Bot Token Scopes | `app_mentions:read`, `channels:history`, `chat:write`, `groups:history`, `im:history`, `reactions:read`, `reactions:write` |
| Event Subscriptions | `app_mention`, `message.groups`, `message.im` |
| 機能 | スレッド返信、ストリーミング応答、リアクション |

---

## 2. 概念図（Mermaid）

### 2.1 全体構成

```mermaid
graph TB
    subgraph Slack["🔵 Slack ワークスペース"]
        CH["📢 チャンネル<br/>(#design-review)"]
        TH["💬 スレッド<br/>(討論セッション)"]
        DM["📩 DM<br/>(ユーザー介入)"]
    end

    subgraph Bolt["⚙️ Bolt for Python"]
        SM["Socket Mode<br/>リスナー"]
        EV["イベント処理<br/>app_mention / message"]
        SAY["say / say_stream<br/>応答送信"]
    end

    subgraph Orch["🎯 オーケストレーター"]
        DP["ディスパッチャー<br/>エージェント起動"]
        RM["ラウンド管理<br/>発言順序制御"]
        CV["収束判断<br/>メドラー結果処理"]
    end

    subgraph Agents["🤖 エージェント群"]
        SK["スキラー<br/>MiMo-V2.5-Pro<br/>技術最適化"]
        HK["ホーク<br/>DeepSeek V3.2 TEE<br/>ユーザ視点"]
        KP["キーパー<br/>Kimi K2.5 TEE<br/>セキュリティ・法務"]
        MD["メドラー<br/>MiMo-V2.5-Pro<br/>取りまとめ"]
    end

    subgraph Chutes["☁️ Chutes API"]
        MIMO["MiMo-V2.5-Pro"]
        DS["DeepSeek V3.2 TEE"]
        KK["Kimi K2.5 TEE"]
    end

    CH -->|"@mention"| SM
    SM --> EV
    EV --> DP
    DP -->|"並行起動"| SK
    DP -->|"並行起動"| HK
    DP -->|"並行起動"| KP
    SK --> MIMO
    HK --> DS
    KP --> KK
    SK -->|"結果"| RM
    HK -->|"結果"| RM
    KP -->|"結果"| RM
    RM -->|"まとめ依頼"| MD
    MD --> MIMO
    MD -->|"取りまとめ結果"| CV
    CV -->|"合意"| SAY
    CV -->|"対立 → 次ラウンド"| RM
    SAY -->|"スレッド投稿"| TH
    DM -->|"人間介入"| CV

    style Slack fill:#4A154B,color:#fff,stroke:#611f69
    style Bolt fill:#2D7DD2,color:#fff,stroke:#1B5EA0
    style Orch fill:#E8A838,color:#333,stroke:#D4952A
    style Agents fill:#2ECC71,color:#fff,stroke:#27AE60
    style Chutes fill:#9B59B6,color:#fff,stroke:#8E44AD
```

### 2.2 討論フロー（詳細）

```mermaid
sequenceDiagram
    participant U as 👤 ユーザー
    participant S as 🔵 Slack
    participant B as ⚙️ Bolt
    participant O as 🎯 オーケストレーター
    participant SK as スキラー
    participant HK as ホーク
    participant KP as キーパー
    participant MD as メドラー

    U->>S: "@bot 設計書をレビューして"
    S->>B: app_mention イベント
    B->>O: 討論開始リクエスト

    Note over O: ラウンド 1 開始

    par 並行発言
        O->>SK: レビュー依頼
        O->>HK: レビュー依頼
        O->>KP: レビュー依頼
    end

    SK-->>O: 技術的観点の意見
    HK-->>O: ユーザ視点の意見
    KP-->>O: セキュリティ・法務の意見

    O->>MD: 3者の意見を渡してまとめ依頼
    MD-->>O: 取りまとめ結果

    alt 合意
        O->>B: 最終結果を送信
        B->>S: スレッドに結果投稿
    else 対立点あり
        Note over O: ラウンド 2 開始
        O->>SK: 対立点について再質問
        O->>HK: 対立点について再質問
        O->>KP: 対立点について再質問
        SK-->>O: 追加意見
        HK-->>O: 追加意見
        KP-->>O: 追加意見
        O->>MD: 再まとめ依頼
        MD-->>O: 最終判断
        O->>B: 最終結果を送信
        B->>S: スレッドに結果投稿
    else 保留
        O->>B: 保留理由を送信
        B->>S: スレッドに保留通知
        U->>S: 人間が判断を入力
    end
```

### 2.3 エージェント間メッセージフロー

```mermaid
graph LR
    subgraph Discussion["討論セッション"]
        direction TB
        R1["ラウンド 1"]
        R2["ラウンド 2"]
        R3["ラウンド 3"]
    end

    subgraph Round["各ラウンド"]
        direction TB
        SK["スキラー発言"] --> HK["ホーク発言"]
        HK --> KP["キーパー発言"]
        KP --> MD["メドラー取りまとめ"]
    end

    R1 --> R2 --> R3

    style R1 fill:#3498DB,color:#fff
    style R2 fill:#E67E22,color:#fff
    style R3 fill:#E74C3C,color:#fff
    style SK fill:#2ECC71,color:#fff
    style HK fill:#F39C12,color:#fff
    style KP fill:#9B59B6,color:#fff
    style MD fill:#1ABC9C,color:#fff
```

---

## 3. 実装方針

### 3.1 Slack スレッド設計

- 各討論セッションは1つのスレッドで管理
- スレッド内でエージェントが順番に発言
- メドラーの取りまとめはスレッド内に投稿
- ユーザーはスレッド内でいつでも介入可能

### 3.2 エージェントの発言形式

```
【スキラー】
技術的観点からの意見:
- ...

【ホーク】
ユーザ視点からの意見:
- ...

【キーパー】
セキュリティ・法務の観点からの意見:
- ...

【メドラー】■ 取りまとめ
合意点: ...
対立点: ...
判断: 合意 / 保留
```

### 3.3 トリガー方式

| トリガー | 方法 |
|---|---|
| ユーザー指示 | `@mention` でエージェント起動 |
| 定期レビュー | Slack Workflow Builder + cron |
| ファイル変更 | watchfiles → Slack にメッセージ投稿 |

---

## 4. 参考プロジェクト

| プロジェクト | 特徴 | 参考価値 |
|---|---|---|
| **agentslack** (Princeton) | マルチエージェントのSlack通信層。並行ワールド、リアルタイム監視 | ★★★★★ |
| **python-slack-agents** | YAML設定ベースのエージェント。MCP tools対応 | ★★★★ |
| **SlackAgents** (Salesforce) | マルチエージェント協調。ワークフローエージェント | ★★★★ |
| **xDebate** | LangGraph ベースの討論フレームワーク。役割分化 | ★★★★★ |
| **ARGUS** | 討論ネイティブフレームワーク。ベイズ推論 | ★★★★ |
