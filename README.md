# cdc

cdcのterraform設定を保存


Test connection failed for endpoint 'database-2-instance-1' and replication config 'postgre-s3-task'. Failure Message: 'Test Endpoint failed: Application-Status: 1020912, Application-Message: Failed to build connection string Unable to find Secrets Manager secret, Application-Detailed-Message: Failed to retrieve secret. Unable to find AWS Secrets Manager secret Arn 'arn:aws:secretsmanager:ap-northeast-1:195706623898:secret:rds!cluster-ebebd44c-47d7-4076-aece-48b84a025283-XOoMOr' The secrets_manager get secret value failed: curlCode: 28, Timeout was reached Too many retries: curlCode: 28, Timeout was reached

Additional info:
Read timed out'

05 22 17:48
Test connection failed for endpoint 'dms-s3-new' and replication config 'postgre-s3-task-new'. Failure Message: 'Test Endpoint failed: Application-Status: 1020912, Application-Message: Failed to connect to database.'

→不明

Test connection failed for endpoint 'instance-1-new' and replication config 'postgre-s3-task-new'. Failure Message: 'Test Endpoint failed: Application-Status: 1020912, Application-Message: Failed to connect  Network error has occurred, Application-Detailed-Message: RetCode: SQL_ERROR  SqlState: 08001 NativeError: 101 Message: [unixODBC]FATAL:  no pg_hba.conf entry for host "172.31.1.64", user "postgres", database "postgres", no encryption

Additional info:
Code: [DMS-00100], Message: [no pg_hba.conf entry for host "172.31.1.64", user "postgres", database "postgres", no encryption], NativeErrorCode: [28000]'

→ssl_mode = "require"が必要

