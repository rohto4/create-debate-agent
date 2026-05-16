# Init Prompt

次のPJで、この `docs/setting/` 一式をコピーしたあと、agentに送る。

```text
docs/setting/init.md を読んで、このPJにAI agent / ECC / docs運用設定を初期導入してください。

PJ名は <PJ-NAME> です。
slugは <PJ-SLUG> です。
目的は <PJ-PURPOSE> です。

PJ固有の方針は次の通りです。
<PJ-POLICY>

主な成果物・機能は次の通りです。
<PJ-FEATURES>
```

## 記入例

```text
docs/setting/init.md を読んで、このPJにAI agent / ECC / docs運用設定を初期導入してください。

PJ名は create-debate-agent です。
slugは create-debate-agent です。
目的は チャット上でエージェント同士を討論させて設計書の品質を向上させるための討論用エージェントを製作することです。

PJ固有の方針は次の通りです。
討論の質を最優先し、複数視点からの検討を構造化する。

主な成果物・機能は次の通りです。
- 討論エージェントのアーキテクチャ設計
- エージェント間の討論プロトコル定義
- 討論の質を評価する基準と検証方法
- 設計書品質の向上手法
- 実装、テスト、運用に関する仕様とメモ
```
