# Tech Stack

作成日: 2026-05-15
更新日: 2026-05-15

## 前提

このPJは「チャット上でエージェント同士を討論させて設計書の品質を向上させる」エージェントを製作する。
Chutes プラットフォーム上で、4つのエージェント（討論3体 + まとめ役1体）を走行させる前提で技術スタックを整理する。

---

## 1. エージェント構成

| エージェント | 役割 | モデル（Chutes） | モード |
|---|---|---|---|
| **スキラー** | 技術最適化 + 堅牢性 | MiMo-V2.5-Pro | - |
| **ホーク** | ユーザ視点 + 要件拡充 | DeepSeek V3.2 | thinking |
| **キーパー** | セキュリティ + 法務 + 経理視点 | Kimi K2.5 TEE | thinking |
| **メドラー** | 取りまとめ + 合意形成 | MiMo-V2.5-Pro | - |

---

## 2. モデル詳細

### 2.1 MiMo-V2.5-Pro（Xiaomi）

- **エージェント**: スキラー、メドラー
- **用途**: 技術最適化、取りまとめ
- **API**: Chutes 経由

### 2.2 DeepSeek V3.2

- **エージェント**: ホーク
- **用途**: ユーザ視点の討論
- **モード**: thinking（段階的推論）
- **API**: OpenAI互換（Chutes 経由）
- **コンテキスト**: 128K tokens

### 2.3 Kimi K2.5 TEE

- **エージェント**: キーパー
- **用途**: セキュリティ、法務、経理視点の討論
- **モード**: thinking（長期推論、Interleaved Thinking対応）
- **API**: OpenAI互換（Chutes 経由）
- **コンテキスト**: 256K tokens
- **特徴**: int4 量子化版、300ステップ tool calling 対応

---

## 3. API互換性

全モデルが **OpenAI互換API** を提供するため、統一インターフェースで扱える。

```python
from openai import OpenAI

# Chutes 経由で各モデルにアクセス
client = OpenAI(api_key="...", base_url="https://chutes.ai/v1")

# スキラー（MiMo-V2.5-Pro）
response = client.chat.completions.create(
    model="xiaomi/MiMo-V2.5-Pro",
    messages=[...]
)

# ホーク（DeepSeek V3.2 thinking）
response = client.chat.completions.create(
    model="deepseek-ai/DeepSeek-V3.2",
    messages=[...],
    extra_body={"chat_template_kwargs": {"thinking": True}}
)

# キーパー（Kimi K2.5 TEE thinking）
response = client.chat.completions.create(
    model="moonshotai/Kimi-K2.5-TEE",
    messages=[...],
    extra_body={"chat_template_kwargs": {"thinking": True}}
)
```

---

## 4. 討論フロー

```text
[ユーザーが議題を投入]
       │
       ▼
  ┌─────────────────────────────────────┐
  │         討論ラウンド開始             │
  │  スキラー → ホーク → キーパー       │
  │  （1往復ずつ発言）                   │
  └─────────────────────────────────────┘
       │
       ▼
  ┌─────────────────────────────────────┐
  │         メドラーの取りまとめ         │
  │  - 各立場の要点                      │
  │  - 合意点                           │
  │  - 対立点                           │
  │  - 次の焦点（もしあれば）             │
  │  - 判断（合意/保留/تصم�يم）        │
  └─────────────────────────────────────┘
       │
       ├── 合意 → 結果をファイル出力
       ├── 対立点あり → 次のラウンドへ
       └── 保留 → 人間に判断を委ねる
```

### 停止条件

- 最大ラウンド数（例: 3ラウンド）
- メドラーが「合意」と判断
- メドラーが「保留」と判断（人間に委ねる）
- 全エージェントが同じ結論に至った

---

## 5. ファイルトリガー技術

### 5.1 可能性

ファイル生成をトリガーとしてAIタスクを実行する技術は、複数のプロジェクトで実用化されている。

| プロジェクト | 仕組み | 特徴 |
|---|---|---|
| **OpenLegion** | File Watchers + cron + webhook | ディレクトリ監視→エージェント起動、Docker volume対応 |
| **Osaurus** | Watchers（200ms〜10min応答段階） | フォルダ監視→AIエージェント実行、冪等性重視 |
| **initrunner** | file_watch trigger | watchfiles使用、globパターン、debounce対応 |
| **AI4PKM** | Orchestrator + YAML設定 | Obsidian vault監視→複数CLIエージェントへの自動ルーティング |

### 5.2 実現可能なアーキテクチャ

```
[ユーザーがチャットで指示]
       │
       ▼
[オーケストレーターがプロンプトファイル生成]
       │
       ▼
[File Watcher が変更を検知]
       │
       ▼
[4つのエージェントに並行タスク配信]
       ├──► スキラー（MiMo-V2.5-Pro）
       ├──► ホーク（DeepSeek V3.2 thinking）
       ├──► キーパー（Kimi K2.5 TEE thinking）
       └──► メドラー（MiMo-V2.5-Pro）※まとめ役
       │
       ▼
[各エージェントが結果ファイルを生成]
       │
       ▼
[メドラーが取りまとめ、結果をファイル出力]
```

---

## 6. 技術スタック決定事項

### 6.1 実装言語

- **Python**: OpenAI SDK対応、エージェントフレームワークのエコシステム

### 6.2 必要なコンポーネント

| コンポーネント | 技術候補 | 備考 |
|---|---|---|
| LLMクライアント | OpenAI SDK (Python) | Chutes 経由で全モデル共通 |
| ファイル監視 | watchfiles (Python) | initrunner/Osaurusで実績 |
| オーケストレーション | 自前実装 | 討論プロトコルに合わせて設計 |
| 設定管理 | YAML | AI4PKMパターン |

---

## 7. 未決定事項

- [ ] 具体的な討論プロトコルの設計
- [ ] チャット常駐の実現方式（Discord bot / Web UI / CLI）
- [ ] 討論結果の永続化形式
- [ ] Chutes の API エンドポイントとモデル ID の確認
