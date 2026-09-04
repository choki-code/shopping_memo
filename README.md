# うちの買い物メモ

家族で共有する買い物リストです。**誰が何を買うかを見えるようにして、買い忘れと重複買いをなくす**ために作りました。

**公開URL** — https://shopping-memo.onrender.com

> 無料プランで動かしているため、アクセスがない状態が続くとサーバーが停止します。初回アクセスは起動に50秒ほどかかることがあります。

## 解決したい課題

家族それぞれが「牛乳を買っておいて」と口頭やLINEで伝え合っていたため、次の2つが起きていました。

- **買い忘れ** — 伝えたつもりが流れてしまう
- **重複買い** — 2人が同じものを買ってくる

紙のメモでは、買った品目に線を引いても他の家族には見えません。**買った状態がその場で全員に共有されること**を最小の解決策と考え、そこだけを作っています。

## 主な機能

| 機能 | 内容 |
|---|---|
| 買い物リストの作成・編集・削除 | 「週末の買い物」のように用途ごとに分けられる |
| 品目の追加・削除 | リストに品目を1つずつ足す |
| 購入状態の切り替え | ☐ を押すと購入済みに移る。未購入と購入済みがセクションで分かれて表示される |

## 使用技術

| 分類 | 内容 |
|---|---|
| 言語 | Ruby 3.4.1 |
| フレームワーク | Rails 8.1 |
| データベース | PostgreSQL（本番 18 / ローカル 17） |
| フロントエンド | Hotwire（Turbo / Stimulus）・Propshaft・Import maps |
| テスト | RSpec（model / request / view / routing / system）・Capybara |
| CI | GitHub Actions（RSpec・RuboCop・Brakeman・bundler-audit・importmap audit） |
| ホスティング | Render |

## ローカルでの動かし方

必要なものは Ruby 3.4.1 と PostgreSQL 17 以上です。

```bash
git clone git@github.com:choki-code/shopping_memo.git
cd shopping_memo
bin/setup
bin/rails s
```

http://localhost:3000 を開きます。

`bin/setup` が gem のインストール、データベースの作成、マイグレーションまで実行します。

## テスト

```bash
bundle exec rspec                # すべて実行
bundle exec rspec spec/system    # system spec のみ
bundle exec rubocop              # 静的解析
```

## 開発の進め方

Issue を立てる → `feature/<issue番号>-<短い英語>` でブランチを切る → 小さくコミットする → PR を出す（何を・なぜ・どう確認したか）→ CI が緑になる → マージする。`main` には直接コミットしません。

## 設計メモ

### 本番のデータベースを1つにしている理由

Rails 8 は既定で solid_cache / solid_queue / solid_cable 用に3つのデータベースを要求します。このアプリはバックグラウンドジョブも WebSocket も使っていないため、本番は primary の1つだけにしました。使っていない機能のためにデータベースを4つ持つより、必要になったときに足す方針です。（`config/database.yml`・`config/environments/production.rb`）

### assume_ssl と force_ssl をセットで有効にしている理由

Render は SSL をロードバランサで終端し、アプリには HTTP で渡します。`assume_ssl` を入れずに `force_ssl` だけを有効にすると、Rails が毎回「HTTP で来た」と判断して HTTPS へリダイレクトし続け、無限ループになります。（`config/environments/production.rb`）
