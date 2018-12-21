# HAS (Hobby Assistant System)
2018年enpit, WebApp3班の課題

## エレベーターピッチ
- **開発を先延ばしにしてしまう状況**を解決したい
- **琉球大学情報工学生の新しい物好き**向けの
- **開発状況を管理して、開発を進めるように促す**ことができる
- 『HAS』です。
- **開発状況が管理**ができ、
- Githubとは違って、
- **他のプロジェクトと進行状況を比較してプロジェクトが進んでいなければ開発を進めるように通知する機能**が備わっています。

## サービスURL
https://hobbyassistantservice.herokuapp.com/

## タスク管理(Trello)
https://trello.com/b/dpkpEYEy/pblsbl


## 必要なもの
- GitHub アカウント（OAuth認証に使う）
- Google アカウント（メール送信元として使う）
  - MAILER_USER_ID
  - MAILER_PASSWORD
  - CLIENT_ID
  - CLIENT_SECRET

    あたりが必要らしい。（サーバーの環境変数($)に追加する。）
- 定期実行してくれるサーバー
  - デプロイ版では、heroku のサービスの **Heroku Scheduler** で、
    rake task を１日おきに実行しています。 
  - 実行するコマンドは `rake updateDB_and_mail.rake:run` です。
  - rake task を定期実行できるサーバーに、↑ のコマンドを登録してください。 

ちゃんと確認したわけではないので、
まだいくつかあるかも。

（試してから更新します）
