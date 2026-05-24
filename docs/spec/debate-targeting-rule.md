# Debate Targeting Rule

作成日: 2026-05-24
更新日: 2026-05-24

## 目的

討論対象の設計書をどのように指定し、エージェントがどこから本文を読むかを一元化する。

この文書を「討論対象指定の正本仕様」とし、他文書には重複記載しない。

## 基本方針

- MoChat に設計書全文をアップロードしない。
- 討論開始時は `manifest` を使って対象ファイル群を宣言する。
- 各エージェントは同一ローカルワークスペース上の対象ファイルを直接読む。
- MoChat には「どの manifest 対象を討論するか」のキックメッセージのみ投稿する。

## 適用条件

この方式は次の条件を満たす場合に適用する。

- 4エージェントが同一ディレクトリ（同一ファイルシステム）を参照できる
- エージェント実装がローカルパス読み取りに対応している
- 対象ファイルの版固定ルールが有効

## Manifest 仕様

推奨配置:
- `docs/spec/target-manifest.yaml`

推奨形式:

```yaml
version: 1
root: G:/devwork/create-debate-agent
targets:
  - id: core-architecture
    paths:
      - docs/spec/system-overview.md
      - docs/spec/tech-stack.md
    focus:
      - consistency
      - feasibility
      - security
    priority: high
```

## キックメッセージ仕様（MoChat投稿）

キックメッセージは最低限次を含める。

- `target_id`
- `paths`
- `focus`
- `output_format`
- `round_limit`

例:

```text
討論開始。
target_id: core-architecture
paths:
- docs/spec/system-overview.md
- docs/spec/tech-stack.md
focus:
- consistency
- feasibility
- security
output_format: 合意点/対立点/保留点
round_limit: 3
```

## 版固定ルール

- 討論開始時に対象ファイルの最終更新時刻またはコミットIDを記録する。
- 討論中は同じ版を参照する。
- 途中で更新された場合は、次セッションで再討論する。

## 失敗時のフォールバック

- 対象ファイルが読めない場合:
  - 当該エージェントは「read_error」として報告
  - メドラーは保留判定または対象除外を提案
- 対象が長大すぎる場合:
  - 先頭から段階投入ではなく、`paths` を分割した複数 `target_id` へ分解する

## 非推奨

- 1000行超の設計書全文を最初にMoChatへ一括投稿する方式
- 対象指定ルールを複数ファイルへ重複記載する方式
