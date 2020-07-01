#配置資訊
$Database	= 'DemoDB'
$Server		= '"TEST"'
$UserName	= 'kk'
$Password	= '123456'
#建立連線物件
$SqlConn = New-Object System.Data.SqlClient.SqlConnection
#使用賬號連線MSSQL
$SqlConn.ConnectionString = "Data Source=$Server;Initial Catalog=$Database;user id=$UserName;pwd=$Password"
#或者以 windows 認證連線 MSSQL
#$SqlConn.ConnectionString = "Data Source=$Server;Initial Catalog=$Database;Integrated Security=SSPI;"
#開啟資料庫連線
$SqlConn.open()
#執行語句方法一
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.connection = $SqlConn
$SqlCmd.commandtext = 'delete top(1) from dbo.B'
$SqlCmd.executenonquery()
#執行語句方法二
$SqlCmd = $SqlConn.CreateCommand()
$SqlCmd.commandtext = 'delete top(1) from dbo.B'
$SqlCmd.ExecuteScalar()
#方法三，查詢顯示
$SqlCmd.commandtext = 'select name,recovery_model_desc,log_reuse_wait_desc from sys.databases'
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$set = New-Object data.dataset
$SqlAdapter.Fill($set)
$set.Tables[0] | Format-Table -Auto 
#關閉資料庫連線
$SqlConn.close()
