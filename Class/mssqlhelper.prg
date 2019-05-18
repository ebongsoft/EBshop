**************************************************
*-- ��:           qiyu_connection (f:\vfpm\���ӿ���\class\qiyu����.vcx)
*-- ����:  custom
*-- ����:    custom
*-- ʱ���:   08/16/17 10:37:05 PM
*
DEFINE CLASS qiyu_connection AS custom


	*-- ���ݿ�
	database = ""
	*-- SQL�������˿ں�
	port = 1433
	*-- ����������IP
	servername = ""
	*-- �û���
	username = ""
	*-- ����
	userpwd = ""

	*-- �Ѵ����ɹ��������б�
	connectionlist = .F.
	*-- ���ݿ�����
	databasetype = ""
	*-- ������
	pjtname = ""
	Name = "qiyu_connection"


	*-- ��ȡ�����ļ�
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
			*-- ��ʱ�ͽ���
			Set Library To myfll ADDITIVE 
			cKey="QiyuSoft"
			lcPwd=ALLTRIM(con_set.pwd)
			cEnStr=Encrypt(lcPwd,cKey) &&ִ�н���
			This.Userpwd=cEnStr
		Else
			Error "û������Ĭ����Ŀ"
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
		*!*		*-- ��ʱ�ͽ���
		*!*		Set Library To myfll
		*!*		cKey="QiyuSoft"
		*!*		lcPwd=ALLTRIM(con_set.pwd)
		*!*		cEnStr=Encrypt(lcPwd,cKey) &&ִ�н���
		*!*		This.Userpwd=cEnStr
		*!*		WAIT con_set.pwd windows
		*!*
		*!*	use
		*!*	If llclose
		*!*	    SELECT con_set 
		*!*		USE
		*!*	ENDIF


		*!*	Catch To oErr
		*!*		oErr.UserValue = "Ƕ�׵Ĳ�����Ϣ: ���ܴ���"
		*!*		?[: Ƕ�ײ���! (�޷������: �����׳� oErr ����) ]
		*!*		?[  �ڲ��쳣����: ]
		*!*		?[  �����: ] + Str(oErr.ErrorNo)
		*!*		?[  �к�: ] + Str(oErr.Lineno)
		*!*		?[  ������Ϣ: ] + oErr.Message
		*!*		?[  �������ڵĹ���/����: ] + oErr.Procedure
		*!*		?[  ��ϸ����: ] + oErr.Details
		*!*		?[  ˮƽ��ջ: ] + Str(oErr.StackLevel)
		*!*		?[  ������: ] + oErr.LineContents
		*!*		?[  �û�: ] + oErr.UserValue
		*!*		Throw oErr
		*!*	Finally
		*!*		?[: Nested FINALLY executed ]
		*!*		If Used("nothing")
		*!*			Use In nothing
		*!*		Endif
		*!*	Endtry
	ENDPROC


	*-- ��������
	PROCEDURE createcon
		LOCAL lnCon,strconn 
		SQLSetprop(0,"DispLogin",3) &&�Ӳ���ʾODBC��¼�Ի�����

		*!*	&&����
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
		    ERROR "���ݿ����Ͳ�֧��"
		ENDCASE 
		lnCon= Sqlstringconnect(strconn )

		Return lnCon

		**lcSQLconn="Driver={SQL Server};Server="+Alltrim(this.Servername)+ALLTRIM(port)+";database="+Alltrim(Database)+";Uid="+Alltrim(admin)+";Pwd="+Alltrim(pwd)
	ENDPROC


	*-- �ر�SQL����
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


	*-- �õ�һ����������
	PROCEDURE getconnection
		If Vartype(connhandle)<>"U"
		&&���ж������Ƿ����
			llvalid=.T.
			Try
				SQLExec(connhandle,"")
			Catch
				llvalid=.F.
			Endtry
			If llvalid  &&������ӿ���,�򷵻���
		         *-- �����Ƿ���æ
				If !SQLGetprop(connhandle,"ConnectBusy")
					Return connhandle
				Else
		            **����һ������
					lcon=this.Createcon()
		 			this.Connectionlist.add(lcon)
					*ERROR  "����æ" 
					Return lcon
				Endif
			Else
		            **����һ������
					lcon=this.Createcon()
					this.Connectionlist.add(lcon)
					*WAIT "���Ӳ�����" windows
					Return lcon
			Endif
		Else
		    **����һ������
			lcon=this.Createcon()
			this.Connectionlist.add(lcon)
			*		WAIT "���Ӳ�����" windows
			Return lcon
		Endif
	ENDPROC


	PROCEDURE Destroy
		&&�ͷ����Ӽ��ϵ�����
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
		**����һ�����Ӽ���
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
    isThrowConectError=.f.  &&�������Ӽ����״��� .t. ����������Ч���������Ӵ���
	Datasource=.F.
	oCon=.f.
	Errno="0"
	Errmsg=""
	nPageCount=0 &&��ҳ��ѯ�ܵ�ҳ��
	nTotal=0  &&��ҳ��ѯ�ܵļ�¼��
	Procedure Init
	Lparameters nCon
	If Empty(nCon)
		*--������ע����������
		This.oCon =Newobject("qiyu_connection","MSSQLhelper.prg")
		This.Datasource=This.oCon.getconnection()		
	Else
		This.Datasource=nCon
		this.isThrowConectError=.t.
	Endif
	Endproc
*-- ���÷���
*--�ж��Ƿ����ĳ���ĳ���ֶ�
*--����:������  ������
*--����:�Ƿ����
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

*-- ִ�м�SQL���
	Function ExecuteSql(strsql As String)
	Local dbcon As Integer,nRow As Integer,oldtable,lcona,nResult
	DIMENSION laerror(1),lcona(2)	
	oldtable=Select()	
	Try
		nResult=SQLExec(This.Datasource,strsql,'',lcona)
		 IF nResult<0
		 	Aerror(laerror)
			DO case
			 	CASE Alen(laerror)>=8   && Ϊ�˺ϲ�Զ�̺ͽ��ˣ���Ҫͳһһ��
			 	     IF  laerror(2,4)='08S01' &&��׽��1526(08S01) ODBC���� ��ͬVFP�����ж�һ��
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
           CASE oErr.errorno=1466 AND this.isThrowConectError=.f. &&�����жϣ����׳�           
               This.errno="1466"
	       CASE oErr.errorno=1098  &&�����Ŵ���  	
	        	Do Case
	        	Case this.errno="S0002"  &&�û������� ���﷨�����׳�
	        	CASE this.errno="37000"	    
	        	   ERROR oErr.Message 	       	  
	        	Otherwise
	        		*Error oErr.Message  &&Ĭ�ϲ���
	        	Endcase  
	    otherwise
	    	*--���������׳�
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
      ERROR "��������Ϊ��"
    ENDIF 
	Dimension lcona[10]
	TRY
		If SQLExec(This.Datasource,strsql,tablename,lcona)<0
		 	Aerror(laerror)
			DO case
			 	CASE Alen(laerror)>=8   && Ϊ�˺ϲ�Զ�̺ͽ��ˣ���Ҫͳһһ��
			 	     IF  laerror(2,4)='08S01' &&��׽��1526(08S01) ODBC���� ��ͬVFP�����ж�һ��
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
           CASE oErr.errorno=1466 AND this.isThrowConectError=.f. &&�����жϣ����׳�           
               This.errno="1466"
	       CASE oErr.errorno=1098  &&�����Ŵ���  	 	           
	        	Do Case
	        	Case this.errno="S0002"  &&�û��������׳�
	        	CASE this.errno="37000"	    	        	
	        	   ERROR oErr.Message 
	        	Otherwise
	        		*Error oErr.Message  &&Ĭ�ϲ���
	        	Endcase
	    otherwise
	    	*--���������׳�
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
			If  Alen(laerror)>=8   && Ϊ�˺ϲ�Զ�̺ͽ��ˣ���Ҫͳһһ��
				If  laerror(2,4)='08S01' &&��׽��1526(08S01) ODBC���� ��ͬVFP�����ж�һ��
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
			    lcError="�޷�������ʱ��,���SQL���:"+ALLTRIM(lcSQLCmd)			   
				Error lcError
			Endif	
				nCol=Field(1,"tmp_table")
				nCol=&nCol			
		ENDIF 
	CATCH TO oErr
		ncol=.null.
		this.errmsg=oErr.message
        Do Case
        Case oErr.ErrorNo=1466 And This.isThrowConectError=.F. &&�����жϣ����׳�
        	This.errno="1466"   
        Case oErr.ErrorNo=1098  &&�������ף�Ĭ�ϲ���
        	Do Case
        	Case this.errno="S0002"  &&�û��������׳�
	       	CASE this.errno="37000"	            	
        	   ERROR oErr.Message 
        	Otherwise
        		*Error oErr.Message  &&Ĭ�ϲ���
        	Endcase
        Otherwise
        	*--���������׳�
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
    
    *-- ��������
    Procedure Reconnect
    Local lnContmp,llcon
    If This.isThrowConectError
      ERROR "���þ���޷�ʹ����������"
    ENDIF 
    
    lnContmp=This.oCon.GetConnection() &&���½�ͨ����
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
 
    *������ǿ�� SQLQuerEX
    *SQLExecEx(nConn, cSQL [, cCursors | cVariables [, cArrayName [, nFlags [, cCursorSchema [, cParamSchema [, cCallback [, nCallbackinterval]]]]]]])
    Procedure SQLQueryEx(strsql As String,tablename As String,cCursorSchema as String,isrefresh as Logical)
    Local nRow As Integer,lntype as Integer	
	nRow =0
    IF Empty(tablename)
      ERROR "��������Ϊ��"
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
    
    *--��ҳ��ѯ Զ�̱���,����+����,�ڼ�ҳ��ҳ���С����ʱ����  ����ֵ��¼��
    *--nPageCount���Դ����ҳ��    
    *--��ҪMSSQL�洢����SelectBase֧�� 
    Function SQLSelectPage(cTableName as string,cWhere as string,nPageNo as Integer,nPageSize as Integer,cAlias as string)
    LOCAL lncount,nRow    	
    IF Empty(cAlias)
      ERROR "��������Ϊ��"
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
			 	CASE Alen(laerror)>=8   && Ϊ�˺ϲ�Զ�̺ͽ��ˣ���Ҫͳһһ��
			 	     IF  laerror(2,4)='08S01' &&��׽��1526(08S01) ODBC���� ��ͬVFP�����ж�һ��
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
           CASE oErr.errorno=1466 AND this.isThrowConectError=.f. &&�����жϣ����׳�           
               This.errno="1466"
	       CASE oErr.errorno=1098  &&�����Ŵ���  	 	           
	        	Do Case
	        	Case this.errno="S0002"  &&�û��������׳�
	        	CASE this.errno="37000"	    	        	
	        	   ERROR oErr.Message 
	        	Otherwise
	        		*Error oErr.Message  &&Ĭ�ϲ���
	        	Endcase
	    otherwise
	    	*--���������׳�
	    	ERROR oErr.message
        ENDCASE
	Endtry
	Return nRow
    ENDFUNC  

Enddefine

