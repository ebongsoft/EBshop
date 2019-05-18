**************************************************
*-- 类:           qiyu_connection (f:\vfpm\祺佑考勤\class\qiyu超类.vcx)
*-- 父类:  custom
*-- 基类:    custom
*-- 时间戳:   08/16/17 10:37:05 PM
*
DEFINE CLASS qiyu_connection AS custom


	*-- 数据库
	database = ""
	*-- SQL服务器端口号
	port = 1433
	*-- 服务器名或IP
	servername = ""
	*-- 用户名
	username = ""
	*-- 密码
	userpwd = ""

	*-- 已创建成功的连接列表
	connectionlist = .F.
	*-- 数据库类型
	databasetype = ""
	*-- 账套名
	pjtname = ""
	Name = "qiyu_connection"


	*-- 读取配置文件
	PROCEDURE readconfig
		Lparameters cZtmc
		Local llclose,lnRecno
		*Try
		oldtable=Select ()
		lnRecno=RECNO()
		If !Used("con_set")
			llclose=.T.
			Use con_set In 0
		Endif
		Select con_set 
		If Empty(cZtmc)
			Locate For choice=1 and !DELETED()
		Else
			Locate For Alltrim(PjtName)==Alltrim(cZtmc) and !DELETED()
		Endif
		If Found()
		    This.pjtname=ALLTRIM(PjtName) 
			This.ServerName=Alltrim(ServerName)
			This.Port=Alltrim(port)
			This.Username=Alltrim(uid)
			This.Database=Alltrim(dbname)
			This.databasetype=UPPER(Alltrim(dbtype))
			_screen.AddProperty("DatabaseType") 
			_screen.DatabaseType=This.databasetype
			*-- 此时就解密
			Set Library To myfll ADDITIVE 
			cKey="QiyuSoft"
			lcPwd=ALLTRIM(con_set.pwd)
			cEnStr=Encrypt(lcPwd,cKey) &&执行解密
			This.Userpwd=cEnStr
		Else
			Error "没有设置默认项目"
		Endif
		If llclose
		    SELECT con_set 
			USE
		ENDIF
		SELECT (oldtable)
		IF USED(oldtable)
		 LOCATE FOR RECNO()=lnRecno 
		ENDIF 


		*!*	Lparameters cZtmc
		*!*	Local llclose,lnRecno
		*!*	*Try

		*!*	If !Used("con_set")
		*!*		llclose=.T.
		*!*		Use con_set In 0
		*!*	Endif
		*!*	Select con_set
		*!*	If Empty(cZtmc)
		*!*		SELECT * FROM con_set where choice=1 into CURSOR con_tmp
		*!*	Else
		*!*	   SELECT * FROM con_set WHERE Alltrim(PjtName)==Alltrim(cZtmc) into CURSOR con_tmp 
		*!*	Endif
		*!*	 Select con_tmp 
		*!*		This.ServerName=Alltrim(ServerName)
		*!*		This.Port=Alltrim(port)
		*!*		This.Username=Alltrim(uid)
		*!*		**This.Userpwd=Alltrim(pwd)
		*!*		This.Database=Alltrim(dbname)
		*!*		This.databasetype=UPPER(Alltrim(dbtype))
		*!*		_screen.AddProperty("DatabaseType") 
		*!*		_screen.DatabaseType=This.databasetype
		*!*		*-- 此时就解密
		*!*		Set Library To myfll
		*!*		cKey="QiyuSoft"
		*!*		lcPwd=ALLTRIM(con_set.pwd)
		*!*		cEnStr=Encrypt(lcPwd,cKey) &&执行解密
		*!*		This.Userpwd=cEnStr
		*!*		WAIT con_set.pwd windows
		*!*
		*!*	use
		*!*	If llclose
		*!*	    SELECT con_set 
		*!*		USE
		*!*	ENDIF


		*!*	Catch To oErr
		*!*		oErr.UserValue = "嵌套的捕获信息: 不能处理"
		*!*		?[: 嵌套捕获! (无法处理的: 向上抛出 oErr 对象) ]
		*!*		?[  内部异常对象: ]
		*!*		?[  错误号: ] + Str(oErr.ErrorNo)
		*!*		?[  行号: ] + Str(oErr.Lineno)
		*!*		?[  错误信息: ] + oErr.Message
		*!*		?[  错误所在的过程/程序: ] + oErr.Procedure
		*!*		?[  详细资料: ] + oErr.Details
		*!*		?[  水平堆栈: ] + Str(oErr.StackLevel)
		*!*		?[  行内容: ] + oErr.LineContents
		*!*		?[  用户: ] + oErr.UserValue
		*!*		Throw oErr
		*!*	Finally
		*!*		?[: Nested FINALLY executed ]
		*!*		If Used("nothing")
		*!*			Use In nothing
		*!*		Endif
		*!*	Endtry
	ENDPROC


	*-- 创建连接
	PROCEDURE createcon
		LOCAL lnCon,strconn 
		SQLSetprop(0,"DispLogin",3) &&从不显示ODBC登录对话窗口

		*!*	&&解密
		*!*	cKey="11223344"
		*!*	lcpwd=userpwd
		*!*	SET LIBRARY TO myfll
		*!*	cEnStr=ALLTRIM(des(lcpwd,cKey,.f.))

		cPort=IIF(EMPTY(this.Port),'',","+this.Port)

		DO CASE 
		CASE this.DatabaseType="MSSQL2008"
			TEXT TO strconn NOSHOW TEXTMERGE 
			DRIVER=SQL Server;SERVER=<<this.Servername>><<cPort>>;;UID=<<this.Username>>;Pwd=<<this.Userpwd>>;Database=<<this.Database>>;Trusted_Connection=No;
			ENDTEXT 
		CASE this.DatabaseType="MSSQL2005"
			TEXT TO strconn NOSHOW TEXTMERGE 
			Driver={SQL Server};Server=<<this.Servername>>,<<this.Port>>;database=<<this.Database>>;Uid=<<this.Username>>;Pwd=<<this.Userpwd>>
			ENDTEXT 
		CASE this.DatabaseType="MSSQL2000"   
			TEXT TO strconn TEXTMERGE NOSHOW
			Driver={SQL Server};Server=<<this.Servername>>,<<this.Port>>;database=<<this.Database>>;Uid=<<this.Username>>;Pwd=<<this.Userpwd>>
			ENDTEXT
		CASE this.DatabaseType="ORACLE"
			TEXT TO strconn TEXTMERGE NOSHOW
			DRIVER={Microsoft ODBC for Oracle};SERVER=<<this.Servername>>;UID=<<this.Username>>;PWD=<<this.Userpwd>>;
			ENDTEXT
		CASE this.DatabaseType="ORACLE11G"
			TEXT TO strconn TEXTMERGE NOSHOW
			DRIVER={Oracle in OraClient11g_home1};SERVER=<<this.Servername>>;UID=<<this.Username>>;PWD=<<this.Userpwd>>;
			ENDTEXT
		CASE this.DatabaseType="ACCESS"
			TEXT TO strconn TEXTMERGE NOSHOW
			Driver={Microsoft Access Driver (*.mdb)};Dbq=<<this.Database>>;Uid=<<this.Username>>;Pwd=<<this.Userpwd>>;
			ENDTEXT
		CASE this.DatabaseType="DB2"
			TEXT TO strconn TEXTMERGE NOSHOW
			driver={IBM DB2 ODBC DRIVER};Database=<<this.Database>>;hostname=<<this.Servername>>;port=<<this.Port>>;protocol=TCPIP; uid=<<this.Username>>; pwd=<<this.Userpwd>>;
			ENDTEXT
		CASE this.Databasetype="MYSQL"
			TEXT TO strconn TEXTMERGE NOSHOW PRETEXT 1+2
			    Driver={MySQL ODBC 3.51 Driver};Server=<<this.Servername>>;Option=131072;Stmt=set names gbk ;Database=<<this.Database>>; User=<<this.Username>>;Password=<<this.Userpwd>>;
			ENDTEXT			
		OTHERWISE
		    ERROR "数据库类型不支持"
		ENDCASE 
		lnCon= Sqlstringconnect(strconn )

		Return lnCon

		**lcSQLconn="Driver={SQL Server};Server="+Alltrim(this.Servername)+ALLTRIM(port)+";database="+Alltrim(Database)+";Uid="+Alltrim(admin)+";Pwd="+Alltrim(pwd)
	ENDPROC


	*-- 关闭SQL连接
	PROCEDURE sqldisconnect
		Lparameters lnconn
		Local llReturn
		llReturn=.T.
		If lnconn>0
			If SQLDisconnect(lnconn)>0
			Else
				llReturn=.F.
			Endif
		Endif
		Return llReturn
	ENDPROC


	*-- 得到一个可用连接
	PROCEDURE getconnection
		If Vartype(connhandle)<>"U"
		&&再判断连接是否可用
			llvalid=.T.
			Try
				SQLExec(connhandle,"")
			Catch
				llvalid=.F.
			Endtry
			If llvalid  &&如果连接可用,则返回它
		         *-- 连接是否正忙
				If !SQLGetprop(connhandle,"ConnectBusy")
					Return connhandle
				Else
		            **创建一个连接
					lcon=this.Createcon()
		 			this.Connectionlist.add(lcon)
					*ERROR  "连接忙" 
					Return lcon
				Endif
			Else
		            **创建一个连接
					lcon=this.Createcon()
					this.Connectionlist.add(lcon)
					*WAIT "连接不可用" windows
					Return lcon
			Endif
		Else
		    **创建一个连接
			lcon=this.Createcon()
			this.Connectionlist.add(lcon)
			*		WAIT "连接不存在" windows
			Return lcon
		Endif
	ENDPROC


	PROCEDURE Destroy
		&&释放连接集合的连接
		Local olist As Collection
		For Each olist In This.Connectionlist
			If olist>0
				SQLDisconnect(olist)
			Endif
		Endfor
	ENDPROC


	PROCEDURE Init
		Lparameters cZtmc
		This.Readconfig(cZtmc)
		**定义一个连接集合
		Local olist As Collection
		olist=Createobject("Collection")
		This.Connectionlist=olist
	ENDPROC


ENDDEFINE
*
*-- EndDefine: qiyu_connection
**************************************************



&& SQLExecEx flags
#DEFINE SQLEXECEX_DEST_CURSOR			0x0001
#DEFINE SQLEXECEX_DEST_VARIABLE			0x0002
#DEFINE SQLEXECEX_REUSE_CURSOR			0x0004
#DEFINE SQLEXECEX_NATIVE_SQL			0x0008
#DEFINE SQLEXECEX_CALLBACK_PROGRESS		0x0010
#DEFINE SQLEXECEX_CALLBACK_INFO			0x0020
#DEFINE SQLEXECEX_STORE_INFO			0x0040

Define Class MSSQLHelper As custom    
    isThrowConectError=.f.  &&控制连接及上抛错误。 .t. 重连方法无效及上抛连接错误
	Datasource=.F.
	oCon=.f.
	Errno="0"
	Errmsg=""
	nPageCount=0 &&分页查询总的页数
	nTotal=0  &&分页查询总的记录数
	Procedure Init
	Lparameters nCon
	If Empty(nCon)
		*--连接类注意生命周期
		This.oCon =Newobject("qiyu_connection","MSSQLhelper.prg")
		This.Datasource=This.oCon.getconnection()		
	Else
		This.Datasource=nCon
		this.isThrowConectError=.t.
	Endif
	Endproc
*-- 公用方法
*--判断是否存在某表的某个字段
*--参数:表名称  列名称
*--返回:是否存在
	Function ColumnExists(tableName As String,columnName As String)
	csql = "select count(1) as col from syscolumns where [id]=object_id('" + tableName + "') and [name]='" + columnName + "'"
	res = This.GetSingle(csql)
	Return Iif(res>0,.T.,.F.)
	Endfunc

	Function GetMaxID(FieldName As String,TableName As String)
	Local strsql As String
	strsql = "select max(" + FieldName + ")+1 from " + TableName
		obj =This.Getsingle(strsql)
	Return obj
	Endfunc

	Function SQLExists(strSql As String)
	Local obj
	res= This.GetSingle(strSql)
	Return Iif(res>0,.T.,.F.)
	Endfunc

*-- 执行简单SQL语句
	Function ExecuteSql(strsql As String)
	Local dbcon As Integer,nRow As Integer,oldtable,lcona,nResult
	DIMENSION laerror(1),lcona(2)	
	oldtable=Select()	
	Try
		nResult=SQLExec(This.Datasource,strsql,'',lcona)
		 IF nResult<0
		 	Aerror(laerror)
			DO case
			 	CASE Alen(laerror)>=8   && 为了合并远程和近端，需要统一一下
			 	     IF  laerror(2,4)='08S01' &&捕捉到1526(08S01) ODBC错误 视同VFP连接中断一样
 		 	  		 	this.errno="1466"
					 	Error 1466  			
					 ELSE
					     This.errno=laerror(1,4)					    
					     ERROR laerror(2)
					 ENDIF     		
             	OTHERWISE
             	    This.errno=laerror(1,4)
					Error laerror(2)
			ENDCASE 
		ELSE
		  nRow=lcona(2)	
		ENDIF 		
	Catch To oErr
	    nRow=-1
        this.errmsg=oErr.message
        DO CASE 
           CASE oErr.errorno=1466 AND this.isThrowConectError=.f. &&连接中断，不抛出           
               This.errno="1466"
	       CASE oErr.errorno=1098  &&特例才处理  	
	        	Do Case
	        	Case this.errno="S0002"  &&用户输错语句 或语法错误抛出
	        	CASE this.errno="37000"	    
	        	   ERROR oErr.Message 	       	  
	        	Otherwise
	        		*Error oErr.Message  &&默认不抛
	        	Endcase  
	    otherwise
	    	*--其它错误，抛出
	    	ERROR oErr.message
        ENDCASE
	ENDTRY

	Select (oldtable)
	Return nRow
	Endfunc

	PROCEDURE SQLQuery(strsql As String,tablename As String)
	Local nRow As Integer,oErrobj as Object		
	nRow =0
    IF Empty(tablename)
      ERROR "表名不能为空"
    ENDIF 
	Dimension lcona[10]
	TRY
		If SQLExec(This.Datasource,strsql,tablename,lcona)<0
		 	Aerror(laerror)
			DO case
			 	CASE Alen(laerror)>=8   && 为了合并远程和近端，需要统一一下
			 	     IF  laerror(2,4)='08S01' &&捕捉到1526(08S01) ODBC错误 视同VFP连接中断一样
 		 	  		 	this.errno="1466"
					 	Error 1466  			
					 ELSE
					     This.errno=TRANSFORM(laerror(1,4))
					     ERROR laerror(2)
					 ENDIF     		
             	OTHERWISE
             	    This.errno=laerror(1,4)
					Error laerror(2)
			ENDCASE 
		Else
			nRow= lcona(2)			
		Endif
	CATCH To oErr
	    nRow=-1
        this.errmsg=oErr.message
        DO CASE 
           CASE oErr.errorno=1466 AND this.isThrowConectError=.f. &&连接中断，不抛出           
               This.errno="1466"
	       CASE oErr.errorno=1098  &&特例才处理  	 	           
	        	Do Case
	        	Case this.errno="S0002"  &&用户输错语句抛出
	        	CASE this.errno="37000"	    	        	
	        	   ERROR oErr.Message 
	        	Otherwise
	        		*Error oErr.Message  &&默认不抛
	        	Endcase
	    otherwise
	    	*--其它错误，抛出
	    	ERROR oErr.message
        ENDCASE
	Endtry
	Return nRow
	ENDPROC 


	Function  GetSingle(lcSQLCmd As String)
	Local dbcon,oldtable,nRow
	Dimension lacath[255],ncol[255]
	oldtable=Select()
	Try
	    nRow=SQLExec(This.Datasource,lcSQLCmd,"tmp_table",lacath)
		IF nRow<0
			Aerror(laerror)
			If  Alen(laerror)>=8   && 为了合并远程和近端，需要统一一下
				If  laerror(2,4)='08S01' &&捕捉到1526(08S01) ODBC错误 视同VFP连接中断一样
					This.errno="1466"
					Error 1466
				Else
					This.errno=laerror(1,4)
					Error laerror(2)
				Endif
			ELSE
			    This.errno=laerror(1,4)
				Error laerror(2)
			EndIF
		ELSE		    
			If !Used("tmp_table")			 
			    lcError="无法生成临时表,检查SQL语句:"+ALLTRIM(lcSQLCmd)			   
				Error lcError
			Endif	
				nCol=Field(1,"tmp_table")
				nCol=&nCol			
		ENDIF 
	CATCH TO oErr
		ncol=.null.
		this.errmsg=oErr.message
        Do Case
        Case oErr.ErrorNo=1466 And This.isThrowConectError=.F. &&连接中断，不抛出
        	This.errno="1466"   
        Case oErr.ErrorNo=1098  &&特例才抛，默认不抛
        	Do Case
        	Case this.errno="S0002"  &&用户输错语句抛出
	       	CASE this.errno="37000"	            	
        	   ERROR oErr.Message 
        	Otherwise
        		*Error oErr.Message  &&默认不抛
        	Endcase
        Otherwise
        	*--其它错误，抛出
        	Error oErr.Message
        Endcase
	FINALLY 
		If Used("tmp_table")
			USE in tmp_table 
		ENDIF 	  
	ENDTRY 
	Select (oldtable)
	Return ncol
	ENDFUNC
    
    *-- 重新连接
    Procedure Reconnect
    Local lnContmp,llcon
    If This.isThrowConectError
      ERROR "共用句柄无法使用重连方法"
    ENDIF 
    
    lnContmp=This.oCon.GetConnection() &&重新接通网络
    Try
    	llcon=Iif(SQLExec(lnContmp,"")>0,.T.,.F.)
    Catch
    	llcon=.F.
    Endtry
  
    IF llcon
    	This.Datasource=lnContmp
    ENDIF
    Return llcon
    Endproc

	Function isconnect
	Local llvalid
	llconect=.T.
	Try
		llconect=Iif(SQLExec(This.Datasource,"")>0,.T.,.F.)
		*	_SCREEN.Print(llconect)
	Catch
		llconect=.F.
	Endtry
	Return llconect
	Endfunc
 
    *－－增强版 SQLQuerEX
    *SQLExecEx(nConn, cSQL [, cCursors | cVariables [, cArrayName [, nFlags [, cCursorSchema [, cParamSchema [, cCallback [, nCallbackinterval]]]]]]])
    Procedure SQLQueryEx(strsql As String,tablename As String,cCursorSchema as String,isrefresh as Logical)
    Local nRow As Integer,lntype as Integer	
	nRow =0
    IF Empty(tablename)
      ERROR "表名不能为空"
    ENDIF 
    
    IF EMPTY(cCursorSchema)
       cCursorSchema=""
    ENDIF 
    IF !USED(tablename)
       lntype= SQLEXECEX_DEST_CURSOR
    ELSE
       lntype= SQLEXECEX_REUSE_CURSOR
    ENDIF 
    
    Set Library To vfp2c32.fll Additive
    DIMENSION laInfo[1,4]
    Try
    	If SQLEXECEX(This.Datasource, strsql ,tablename,"laInfo",lntype,cCursorSchema)>0
    		nRow=laInfo[1,2]
    	Else
    		nRow=-1
    		AERROREX("laError")
    		Error laerror(2)
    	Endif
    Catch To ex
    	Error ex.Message
    Endtry

    Endproc
    
    *--分页查询 远程表名,条件+排序,第几页，页面大小，临时表名  返回值记录数
    *--nPageCount属性存放总页数    
    *--需要MSSQL存储过程SelectBase支持 
    Function SQLSelectPage(cTableName as string,cWhere as string,nPageNo as Integer,nPageSize as Integer,cAlias as string)
    LOCAL lncount,nRow    	
    IF Empty(cAlias)
      ERROR "表名不能为空"
    ENDIF 
	Dimension lcona[10]
	lncount=0    
	TEXT TO lcSQLCmd NOSHOW TEXTMERGE 
	exec selectbase ?nPageNo,?nPageSize,?cTableName,?cwhere,?@lncount      
	ENDTEXT 	
	
	Try
		If SQLExec(This.Datasource,lcSQLCmd,cAlias,lcona)<0		   
		 	Aerror(laerror)
			DO case
			 	CASE Alen(laerror)>=8   && 为了合并远程和近端，需要统一一下
			 	     IF  laerror(2,4)='08S01' &&捕捉到1526(08S01) ODBC错误 视同VFP连接中断一样
 		 	  		 	this.errno="1466"
					 	Error 1466  			
					 ELSE
					     This.errno=TRANSFORM(laerror(1,4))
					     ERROR laerror(2)
					 ENDIF     		
             	OTHERWISE
             	    This.errno=laerror(1,4)
					Error laerror(2)
			ENDCASE 		
		ELSE
			nRow= lcona(2)	
		ENDIF
		This.nPageCount=CEILING(lncount/nPageSize)
		this.nTotal=lncount
	Catch To oErr	
	    nRow=-1
        this.errmsg=oErr.message
        DO CASE 
           CASE oErr.errorno=1466 AND this.isThrowConectError=.f. &&连接中断，不抛出           
               This.errno="1466"
	       CASE oErr.errorno=1098  &&特例才处理  	 	           
	        	Do Case
	        	Case this.errno="S0002"  &&用户输错语句抛出
	        	CASE this.errno="37000"	    	        	
	        	   ERROR oErr.Message 
	        	Otherwise
	        		*Error oErr.Message  &&默认不抛
	        	Endcase
	    otherwise
	    	*--其它错误，抛出
	    	ERROR oErr.message
        ENDCASE
	Endtry
	Return nRow
    ENDFUNC  

Enddefine

