# cdc

Test connection failed for endpoint 'instance-1-new' and replication config 'postgre-s3-task-new'. Failure Message: 'Test Endpoint failed: Application-Status: 1020912, Application-Message: Failed to connect  Network error has occurred, Application-Detailed-Message: RetCode: SQL_ERROR  SqlState: 08001 NativeError: 101 Message: [unixODBC]FATAL:  no pg_hba.conf entry for host "172.31.1.64", user "postgres", database "postgres", no encryption

Additional info:
Code: [DMS-00100], Message: [no pg_hba.conf entry for host "172.31.1.64", user "postgres", database "postgres", no encryption], NativeErrorCode: [28000]'

→ソースエンドポイントに、ssl_mode = "require"が必要だった


05 22 17:48
Test connection failed for endpoint 'dms-s3-new' and replication config 'postgre-s3-task-new'. Failure Message: 'Test Endpoint failed: Application-Status: 1020912, Application-Message: Failed to connect to database.'

→RDSとDMSのタスクを再起動すると解決したので設定の未反映？


DMSタスクを実行したら「ロード完了 (エラーあり)、レプリケーションが進行中 
フルロードが完了しましたが、テーブルエラーが発生しました。CDC レプリケーションが進行中です。エラーの詳細はタスクの詳細ページの [テーブル統計] のタブ で確認できます。Table error

→DMSの詳細ログが出力されるように変更。
　対象RDSテーブルへの書き込み時にログにでていたのでCDCは成功していそうだったが、S3に出力はなし。
　何かが失敗している内容のログはなし。
　テーブル統計タブでは、Table errorとしか出ていなかった。

