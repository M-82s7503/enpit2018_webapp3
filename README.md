# HAS (Hobby Assistant System)

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
  - CLIENT_ID
  - CLIENT_SECRET
- Google アカウント（メール送信元として使う）
  - MAILER_USER_ID
  - MAILER_PASSWORD

    あたりが必要らしい。（サーバーの環境変数(シェル変数)に追加する。）
    
- rake task を定期実行してくれるサーバー
  - デプロイ版では、heroku のサービスの **Heroku Scheduler** を使って、
    rake task を１日おきに実行しています。 
  - 実行するコマンドは `rake updateDB_and_mail:run` です。
  - rake task を定期実行できるサーバーに、↑ のコマンドを登録してください。 


## 手順（メモ）
1. git clone, cd する。
2. GitHub OAuth の認証元にするための GitHub アカウントを用意して、  
  GitHub Apps を作成する（CLIENT_ID, CLIENT_SECRETを取得する）。    
    https://github.com/settings/apps  
  → `Client ID`, `Client secret` を .zshrc などに環境変数として登録する。
  必要な権限は、
3. Gmail を設定する
  - Googleのアカウントを作成
  - ２段階認証を［有効］にする
  - アプリパスワードを発行する  
  → .zshrc などに環境変数として設定する。
    - MAILER_USER_ID = Gmailのメルアド@gmail.com
    - MAILER_PASSWORD = アプリパスワード
4. 定期実行スクリプトとして、１日おきで `rake updateDB_and_mail:run` を登録する。

___

2018年enpit, WebApp3班
