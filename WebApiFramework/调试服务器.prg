*_SCREEN.Visible = .F.
SET TALK OFF
CLEAR
*ON ERROR _OnError(ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO())

#DEFINE WM_SOCKET    0x400 + 100

DECLARE LONG WSAGetLastError IN "Ws2_32"
DECLARE LONG WSAStartup IN "Ws2_32" LONG, STRING@
DECLARE LONG WSACleanup IN "Ws2_32"
DECLARE LONG socket IN "Ws2_32" LONG, LONG, LONG 
DECLARE LONG closesocket IN "Ws2_32" LONG
DECLARE LONG WSAAsyncSelect IN "Ws2_32" LONG, LONG, LONG, LONG
DECLARE LONG bind IN "Ws2_32" AS _bind LONG, STRING@, LONG
DECLARE LONG listen IN "Ws2_32" LONG, LONG
DECLARE LONG accept IN "Ws2_32" LONG, STRING@, LONG@
DECLARE LONG recv IN "Ws2_32" LONG, STRING@, LONG, LONG 
DECLARE LONG send IN "Ws2_32" LONG, STRING@, LONG, LONG 
DECLARE LONG inet_addr IN "Ws2_32" STRING@
DECLARE LONG htons IN "Ws2_32" LONG



PUBLIC oForm
oForm = NEWOBJECT("WebServerForm")
oForm.Show
*!*	READ EVENTS
*!*	CLOSE DATABASES ALL 
*!*	CLEAR DLLS
*!*	ON ERROR
*!*	_SCREEN.Visible = .T.
*!*	RETURN


DEFINE CLASS WebServerForm As Form
    Width = 400
    Height = 310
    Caption="祺佑调试服务器"
    Desktop = .T.
    ShowWindow = 2
    WindowType = 1
    AutoCenter = .T.
    AlwaysOnTop = .T.
    AllowOutput=.F.
    BorderStyle = 0   
    isStart=.f.
    Add Object Label1 As Label WITH Top = 10, Left = 10, AutoSize = .T.,;
        Caption = "本端: IP                  端口"
    Add Object Text1 As TextBox WITH Top = 6, Left = 60, Width = 100, Height = 20
    Add Object Text2 As TextBox WITH Top = 6, Left = 190, Width = 40, Height = 20, value = 801
    Add Object Command1 As CommandButton WITH Top = 6, Left = 235, Width = 70, Height = 20,;
        Caption = "启动服务"

    Add Object Command2 As CommandButton WITH Top = 6, Left = 320, Width = 70, Height = 20,;
        Caption = "清屏"

    Add Object Edit1 As EditBox WITH Top = 32, Left = 10, Width = 380, Height = 270

    Add Object SocketWeb1  As SocketWeb
    Add Object SocketHttp1 As SocketHttp
    Add Object HttpHead1   As HttpHead

    PROCEDURE Load
    Public ofrmMain
    ofrmMain=this
    Set Path To [WebAPIframework] Additive
	Set Path To [Controller] Additive
	Set Library To myfll Additive
    Set Library To foxjson.FLL  Additive  
    SET PROCEDURE TO QiyuWebLib.prg ADDITIVE 
    Set Procedure To foxjson Additive
    Set Procedure To foxjson_parse Additive
    ENDPROC 
  
    PROCEDURE Init
        LOCAL oIPs
        BINDEVENT(this.hWnd, WM_SOCKET, this.SocketWeb1, "_SocketMsg")

        oIPs = GETOBJECT('winmgmts:')
        oIPs = oIPs.InstancesOf('Win32_NetworkAdapterConfiguration')
        FOR EACH oIP IN oIPs
            IF oIP.IPEnabled
                this.Text1.Value = oIP.IPAddress[0]
                EXIT
            ENDIF
        ENDFOR
        
        this.AlwaysOnTop = .F.
        thisform.Command1.click()
    ENDPROC
    
    PROCEDURE Unload
        CLEAR EVENTS
    ENDPROC
    
    PROCEDURE Command1.Click
        IF !thisform.isStart
	        szRet = thisform.SocketWeb1._SetListen(thisform.hWnd,;
	                                               ALLTRIM(thisform.Text1.Value),;
	                                               thisform.Text2.Value)
	        thisform._WriteMsg(szRet)       
	        this.Caption="停止服务"
	        
        ELSE
           szRet =thisform.SocketWeb1._closeListen(thisform.hWnd,;
	                                               ALLTRIM(thisform.Text1.Value),;
	                                               thisform.Text2.Value)
	       thisform._WriteMsg(szRet )                                          
     	   this.Caption="开启服务"
        ENDIF 
        thisform.isStart=!thisform.isStart
    ENDPROC

    PROCEDURE Command2.Click
        thisform.Edit1.Value = ""
    ENDPROC

    PROCEDURE _WriteMsg
        LPARAMETERS szMsg
        this.Edit1.Value = this.Edit1.Value + szMsg + 0h0D0A
        this.Edit1.SelStart = LEN(this.Edit1.Text)
        this.Edit1.SelLength = 0
    ENDPROC
    
    PROCEDURE SocketWeb1._OnRead
        LPARAMETERS iConnID, szReadBuf
         *STRTOFILE(szReadBuf,"1.txt",1)
         thisform.HttpHead1.GetFields(szReadBuf)       
         thisform.HttpHead1.httpheader=szReadBuf
         *?szReadBuf
          *thisform.Edit1.value=szReadBuf       
       
        LOCAL RequestObject,RequestObject,oControll,RetHtml,cProc
        m.RetHtml=""
        cUrlPath=thisform.HttpHead1.Url      
        LOCAL cFileName,lnstart,lnpo,lnend
        lnstart=RAT("/",cUrlPath)
		lnpo=RAT("?",cUrlPath)
		lnend=IIF(lnpo==0,LEN(cUrlPath)+1,lnpo)
		cFileName=SUBSTR(cUrlPath,lnstart+1,lnend-2)       
        *oFrmMain.log(cUrlPath)        
        m.RequestObject=JUSTSTEM(cFileName) &&RIGHT(cUrlPath,LEN(cUrlPath)-RAT("/",cUrlPath))
        m.RequestExtName=JUSTEXT(cFileName)
        m.classfile=RequestObject+".prg"
        *--常规文件处理
        IF UPPER(m.RequestExtName)!="FSP"
          TRY           
          cHost=thisform.HttpHead1.host   &&"qiyusoft.free.ngrok.cc"         
          IF cHost$cUrlPath         
		    lnStart=AT(cHost,cUrlPath)+LEN(cHost)
		    lnLen=LEN(cUrlPath)-lnStart
		     cFilePath=SUBSTR(cUrlPath,lnStart+1,lnlen)
		  ELSE
		     cFilePath=cUrlPath
		  ENDIF   
		  lnpo=RAT("?",cFilePath)
		  IF lnpo>0
		   cFilePath="wwwroot"+LEFT(cFilePath,lnpo-1)
		  ELSE  
		  cFilePath="wwwroot"+cFilePath
		  ENDIF 
		 
		  *?cFilePath,m.RequestExtName,this.getContentType(m.RequestExtName)
          cResult=FILETOSTR(cFilePath)
         * cResult=FILETOSTR("wwwroot\"+m.RequestObject+"."+m.RequestExtName)        
         Thisform.SocketHttp1.contenttype=Thisform.getContentType(m.RequestExtName)        
         IF EMPTY( Thisform.SocketHttp1.contenttype)
            Thisform.SocketHttp1.contenttype="text\html"
         ENDIF 
          Thisform.SocketHttp1.Qiyu_Write(cResult,iConnid)
          CATCH TO ex
            Thisform.SocketHttp1.Qiyu_Write(m.RequestObject+"."+m.RequestExtName+ex.message,iConnid)
            oFrmMain.log(m.RequestObject+"."+m.RequestExtName+ex.message)
          ENDTRY 
          RETURN
        ENDIF 
        
		Try
			oHttpcontext=Newobject("HttpContext","HttpContext.prg")
	        oFrmMain.Log(oHttpcontext.getAbsoluteUri())
	        lcappuser=Alltrim(Thisform.SocketHttp1.Qiyu_Request("appuser")) &&appuser必传,支持多用户	        
			oControll=Newobject(m.RequestObject,m.classfile)  && BS框架再考虑了 如果能找到类库，则类执行运算,如果不是，则由默认类去执行
			oCtlObjType=oControll.ParentClass
			*--得到参数 调用类方法
		    cProc= Thisform.SocketHttp1.Qiyu_Request("proc")
		    
			*--判断是父类wxapi weixinfsp
			Do Case
				Case Upper(oControll.ParentClass)==Upper("weixinApi")
					If Empty(lcappuser)
						Error "请传入Appuser参数"
					Endif

					oControll.appuser=lcappuser
					cProc="AnswerMsg"

				Case Upper(oControll.ParentClass)=="WEIXINFSP"
					If Empty(lcappuser)
						Error "请传入Appuser参数"
					Endif					
					oControll.appuser=lcappuser
					
					* OTHERWISE
					* oControll=Newobject(m.RequestObject,m.classfile)  && BS框架再考虑了 如果能找到类库，则类执行运算,如果不是，则由默认类去执行
			Endcase
								

		    lcCmd="oControll."+cProc+"()"
		    ofrmMain.Log(cUrlPath+CHR(13)+oControll.Name+"."+cProc+"接收成功")  &&写入日志
			IF !PEMSTATUS(oControll,cProc,5)
			  ERROR m.RequestObject+"."+cProc+"类的方法不存在"
			ENDIF 
			IF !PEMSTATUS(oControll,'iConnid',5)  &&添加一个iConnid属性
			 ADDPROPERTY(oControll,'iConnid',iConnid)
			ENDIF  
			oControll.iConnid=iConnid			
			
			*--判断是父类wxapi weixinfsp
			Do Case
				Case Upper(oControll.ParentClass)=="WXAPI"
					&lccmd &&执行命令
				Otherwise					
					Local RetHtml
					m.RetHtml=Transform(&lccmd)
					*ofrmMain.Log(WebGetUri()+Chr(13)+oControll.Name+"."+cProc+"调用成功")  &&写入日志
					Thisform.SocketHttp1.Qiyu_Write(strconv(m.RetHtml,9),m.iConnID) &&转码成UTF-8
					*fws_write(m.RetHtml)    &&将处理结果输出给浏览器
					ofrmMain.Log(cUrlPath+CHR(13)+oControll.Name+"."+cProc+"调用成功")  &&写入日志
			Endcase
			
		Catch To ex
		    *ofrmMain.Log("系统错误:"+ex.Message)  &&写入日志
		    objall=Createobject("foxjson")  
		    objall.Append("errno",ex.errorno)
		    objall.Append("errmsg",ex.message)
			objall.Append("success","false") 
			objall.Append("errorMsg",ex.message+",过程:"+ ex.Procedure+",行号:"+TRANSFORM(ex.LineNo))  &&可以开发状态显示
			*objall.Append("errorMsg",ex.message)
			objall.Append("total ",0)	
			orows=CREATEOBJECT("foxjson",{})
			objall.append("rows",orows.tostring())
			ofrmMain.Log(objall.tostring())
			*HttpWrite(iConnid,STRCONV(objall.tostring(),9))				
			Thisform.SocketHttp1.Qiyu_Write(STRCONV(objall.tostring(),9),iConnID)
		Endtry
         
        *thisform._WriteMsg(szReadBuf)                         &&调试信息
        *thisform._WriteMsg(_WriteFields(thisform.HttpHead1))  &&调试信息
      * thisform.Edit1.value=thisform.HttpHead1.Url+thisform.Edit1.value
      *thisform.SocketHttp1._SendError(_hSocket)
      *thisform.SocketHttp1.Qiyu_Write("123",_hSocket)
     
*!*	        DO CASE 
*!*	        CASE thisform.HttpHead1.Url == "/"
*!*	            thisform.SocketHttp1._SendLogin(_hSocket)
*!*	        CASE "Submit" $ thisform.HttpHead1.Url
*!*	            IF ALINES(aUrl, thisform.HttpHead1.Url, "&") == 3
*!*	                IF STRCONV(STRTRAN(RIGHT(aUrl[3], 12), "%", ""), 16) == "登录"
*!*	                    aUrl[1] = STUFF(aUrl[1], 1, AT("=", aUrl[1]), "")
*!*	                    aUrl[2] = STUFF(aUrl[2], 1, AT("=", aUrl[2]), "")
*!*	                    IF LEFT(aUrl[1], 1) == "%"
*!*	                        aUrl[1] = STRCONV(STRTRAN(aUrl[1], "%", ""), 16)
*!*	                    ENDIF
*!*	                    IF LEFT(aUrl[2], 1) == "%"
*!*	                        aUrl[2] = STRCONV(STRTRAN(aUrl[2], "%", ""), 16)
*!*	                    ENDIF
*!*	                    SELECT TEMP
*!*	                    LOCATE FOR (ALLTRIM(用户名) == aUrl[1]) AND (ALLTRIM(密码) == aUrl[2])
*!*	                    IF FOUND()
*!*	                        thisform.SocketHttp1._SendBrowse(_hSocket)
*!*	                    ELSE
*!*	                        thisform.SocketHttp1._SendError(_hSocket)
*!*	                    ENDIF
*!*	                ENDIF
*!*	            ENDIF
*!*	        ENDCASE
    ENDPROC
    
    PROCEDURE log
    Lparameters uValue
    Thisform.edit1.Value = Thisform.edit1.Value + uValue+ttoc(DATETIME())+CHR(13)
    ENDPROC 
    
    PROCEDURE getContentType
    LPARAMETERS lcExtname
    LOCAL lcResult
    lcResult="text/html"
     IF !used("contype")
       USE contype IN 0
     ENDIF 
     SELECT contype
     LOCATE FOR ALLTRIM(extName)==lcExtname
     IF FOUND()
        lcResult=contype
     ENDIF      
     USE IN SELECT("contype")
     RETURN lcResult
    ENDPROC 
    
    
ENDDEFINE


DEFINE CLASS SocketWeb AS Session
    hWnd    = 0
    hSocket = 0

    PROCEDURE Destroy
         this._CloseSocket()
    ENDPROC
    
    PROCEDURE _CloseSocket
        closesocket(this.hSocket)
        WSACleanup()
    ENDPROC

    PROCEDURE _CloseListen
        LPARAMETERS hWnd, szIP, nPort
        LOCAL stWsaData, stSockAddr
        this._CloseSocket()        
        RETURN "停止服务成功"
    ENDPROC


    PROCEDURE _SetListen
        LPARAMETERS hWnd, szIP, nPort
        LOCAL stWsaData, stSockAddr
        this._CloseSocket()
        
        this.hWnd  = hWnd
        stWsaData  = REPLICATE(0h00, 398)
        WSAStartup(0x202, @stWsaData)
        this.hSocket = socket(2, 1, 0)
        WSAAsyncSelect(this.hSocket, this.hWnd, WM_SOCKET, 8)    && FD_ACCEPT
        *?BINTOC(htons(nPort), "2RS"),htons(nPort)
*!*	        stSockAddr = BINTOC(2, "2RS");                   && sin_family
*!*	                   + BINTOC(htons(nPort), "2RS");        && sin_port
*!*	                   + BINTOC(inet_addr(@szIP), "4RS");    && sin_addr
*!*	                   + REPLICATE(0h00, 8)

        stSockAddr = BINTOC(2, "2RS");                   && sin_family
                   + RIGHT(BINTOC(nPort, "2RS"),1)+left(BINTOC(nPort, "2RS"),1);        && sin_port
                   + BINTOC(inet_addr(@szIP), "4RS");    && sin_addr
                   + REPLICATE(0h00, 8)

        IF _bind(this.hSocket, @stSockAddr, LEN(stSockAddr)) == -1
            RETURN "不能绑定到IP:" + szIP + " 端口:" + TRANSFORM(nPort)
        ELSE
            listen(this.hSocket, 10)                      && 监听，队列限制10
            RETURN "启动服务成功"
        ENDIF

*!*	        stSockAddr = BINTOC(2, "2RS");                   && sin_family
*!*	                   + BINTOC(htons(nPort), "2RS");        && sin_port
*!*	                   + BINTOC(inet_addr("127.0.0.1"), "4RS");    && sin_addr
*!*	                   + REPLICATE(0h00, 8)

*!*	        IF _bind(this.hSocket, @stSockAddr, LEN(stSockAddr)) == -1
*!*	            RETURN "不能绑定到IP:" + szIP + " 端口:" + TRANSFORM(nPort)
*!*	        ELSE
*!*	            listen(this.hSocket, 5)                      && 监听，队列限制5
*!*	            RETURN "启动服务成功"
*!*	        ENDIF


    ENDPROC

    * 添加一个客户端socket
    PROCEDURE _AddClient
        LPARAMETERS _hSocket
        LOCAL stSockAddr, nSize
        stSockAddr = REPLICATE(0h00, 16)
        nSize      = LEN(stSockAddr)
        _hSocket = accept(_hSocket, @stSockAddr, @nSize)
        IF _hSocket != -1
            WSAAsyncSelect(_hSocket, this.hWnd, WM_SOCKET, 33)  && FD_READ or FD_CLOSE
        ENDIF
    ENDPROC

    PROCEDURE _OnRead
        LPARAMETERS _hSocket, szReadBuf
    ENDPROC

    TmpData=""
    boundary=""
    * 接收到数据包
    PROCEDURE _RecvData
        LPARAMETERS _hSocket
        LOCAL szReadBuf, nDataLen,nStart,cParseChar 
        szReadBuf = SPACE(32768)    && 32 * 1024
        *?"len",LEN(szReadBuf)
        nDataLen = recv(_hSocket, @szReadBuf, LEN(szReadBuf), 0)        
        *?"nDataLen",nDataLen 
        IF nDataLen > 0
            szReadBuf = LEFT(szReadBuf, nDataLen)
            *--解析一下报文
            nStart=AT(CHR(13),szReadBuf)   
            DO CASE          
            CASE  "POST"$UPPER(left(szReadBuf,nstart))
                  *//能否找到                  
                   m.cParseChar = Strextract(szReadBuf, "boundary=", CHR(13)) 
                   this.boundary=  m.cParseChar       
                    &&说明有文件流  再判断文件尾部          
                   IF !EMPTY(m.cParseChar) AND !RIGHT(szReadBuf,LEN(m.cParseChar))==m.cParseChar                    
                     this.TmpData = this.TmpData + szReadBuf                      
                     *?"有文件流"
                   ELSE 
                     this._OnRead(_hSocket, szReadBuf)
                     closesocket(_hSocket)
                   ENDIF 
            CASE  "GET"$UPPER(left(szReadBuf,nstart))
                   this._OnRead(_hSocket, szReadBuf)
                   closesocket(_hSocket)
              &&说明是文件流 或GET   
            OTHERWISE   
             *--将数据流合并
             this.TmpData = this.TmpData + szReadBuf           
             *?"文件流合并",RIGHT(szReadBuf,LEN(this.boundary)), this.boundary     
             LOCAL tmpx1
             tmpx1=LEFT(RIGHT(szReadBuf,LEN(this.boundary)+4),LEN(this.boundary)+2)
             IF tmpx1==this.boundary+"--"         
                *说明是尾部了                
                *?"文件流结束"
                 *STRTOFILE(this.tmpData,"x4.txt")
                 this._OnRead(_hSocket, this.TmpData)
*!*	                  lOCAL szHead
*!*	                szHead = [HTTP/1.1 200 OK] + 0h0D0A +;
*!*	                 [Content-Type: ]+[text/html] + 0h0D0A+; 
*!*	                 [Access-Control-Allow-Origin:*]+ 0h0D0A
*!*	                 szHead = szHead +[Content-Length: ] + "2" + 0h0D0A0D0A+CHR(13)+CHR(13)
*!*					IF send(_hSocket, @szHead , LEN(szHead ), 0) == -1
*!*					     IF WSAGetLastError() == 10035    && WSAEWOULDBLOC
*!*					     ?"网络繁忙"
*!*					     ENDIF
*!*					ENDIF             
                * this._SendData(_hSocket, szHead)
                * this._SendData(_hSocket, _senddata)
                 closesocket(_hSocket)
                 this.TmpData=""
                 this.boundary =""
             ENDIF 
              
            ENDCASE      
        ELSE
             closesocket(_hSocket)
        ENDIF
    ENDPROC

    * 网络消息处理
    PROCEDURE _SocketMsg
        LPARAMETERS hWnd, Msg, wParam, lParam
        DO CASE
        CASE lParam == 0x0008                && FD_ACCEPT      接收将要连接的通知
            this._AddClient(wParam)
        CASE lParam == 0x0001                && FD_READ        接收读准备好的通知   
            this._RecvData(wParam)
        CASE lParam == 0x0020                && FD_CLOSE       接收套接口关闭的通知
            closesocket(wParam)
        OTHERWISE
        ENDCASE
    ENDPROC
ENDDEFINE

DEFINE CLASS SocketHttp AS Session
    contenttype="text/html"   &&默认text/html
    
    PROCEDURE _SendLogin
        LPARAMETERS _hSocket
        LOCAL szHead, szHtml
        szHtml = [<html><body><form name="Login" action="" method="get">] + 0h0D0A +;
                 [用户名<input class="input" type="text" name="Username" value="张三" size="20" />] + 0h0D0A +;
                 [密码<input class="input" type="password" name="Password" value="123" size="20" />] + 0h0D0A +;
                 [<input class="btn" type="submit" name="Submit" value="登录" style="width:80px" />] + 0h0D0A +;
                 [</form></body></html>]

        szHead = [HTTP/1.1 200 OK] + 0h0D0A +;
                 [Content-Type: text/html] + 0h0D0A +;
                 [Content-Length: ] + TRANSFORM(LEN(szHtml)) + 0h0D0A0D0A
                 
        this._SendData(_hSocket, szHead)
        this._SendData(_hSocket, szHtml)
    ENDPROC

    PROCEDURE _SendBrowse
        LPARAMETERS _hSocket
        LOCAL szHead, szHtml
        szHtml = [<html><body>] + 0h0D0A +;
                 [<table border="1">] + 0h0D0A +;
                 [<tr><td>编号</td><td>用户名</td><td>密码</td></tr>] + 0h0D0A
        select TEMP
        SCAN
            szHtml = szHtml +;  
                     [<tr><td>] + RTRIM(编号) + [</td><td>] + RTRIM(用户名) + [</td><td>] + RTRIM(密码) + [</td></tr>] + 0h0D0A
        ENDSCAN
        szHtml = szHtml + [</table></body></html>]
        
        szHead = [HTTP/1.1 200 OK] + 0h0D0A +;
                 [Content-Type: text/html] + 0h0D0A +;
                 [Content-Length: ] + TRANSFORM(LEN(szHtml)) + 0h0D0A0D0A
                 
        this._SendData(_hSocket, szHead)
        this._SendData(_hSocket, szHtml)
    ENDPROC
    
*!*	    "HTTP/1.1 302 Moved Temporarily"
*!*	    "Location: 路径"

    PROCEDURE _HttpRedirect
        LPARAMETERS cRedirectUrl,_hSocket
        LOCAL szHead        
        szHead = [HTTP/1.1 302 Moved Temporarily] + 0h0D0A +;
                 [Location:]+cRedirectUrl+ 0h0D0A0D0A 
        this._SendData(_hSocket, szHead)     
    ENDPROC

    
    PROCEDURE _SendError
        LPARAMETERS _hSocket
        this._SendData(_hSocket,; 
                       [HTTP/1.1 200 OK] +  + 0h0D0A +;
                       [Content-Type: text/html] + 0h0D0A0D0A +;
                       [<h1>404 登录失败</h1>] + 0h0D0A +;
                       [输入的用户名或密码有误])
    ENDPROC

    * 发送数据包
    PROCEDURE _SendData
        LPARAMETERS _hSocket, szDate
        IF send(_hSocket, @szDate, LEN(szDate), 0) == -1
            IF WSAGetLastError() == 10035    && WSAEWOULDBLOCK
                RETURN "网络繁忙，请稍候发送。"
            ELSE
                RETURN "发送失败"
            ENDIF
        ENDIF
        RETURN ""
    ENDPROC
    
    PROCEDURE Qiyu_Request
     LPARAMETERS _paramkey,_hSocket
     LOCAL _cUrlPath,_cResult
     _cResult=""
     
     _cUrlPath=urldecode(thisform.HttpHead1.Url)  &&UTF码
     _nstart=AT("?",_cUrlPath)+1
	 _cUrlPath=SUBSTR(_cUrlPath,_nstart,LEN(_cUrlPath)-_nstart+1)
	*按& 分列成数组
	ALINES(_laarray,_cUrlPath,2,"&")
	FOR i=1 TO alen(_laarray)
	  *--  =号前为key,后为value
	  _nstart=AT("=",_laarray[i])
	  _cKey=SUBSTR(_laarray[i],1,_nstart-1)
	  *_cValue=SUBSTR(laarray[i],_nstart+1,LEN(_laarray[i])-_nstart)
	  IF _cKey==_paramkey
	    _cResult=SUBSTR(_laarray[i],_nstart+1,LEN(_laarray[i])-_nstart)
	  ENDIF 
	NEXT 
      RETURN _cResult
    ENDPROC 
    
    PROCEDURE Qiyu_FormParams
    LPARAMETERS  _paramkey,_hSocket
   	tcHttpheader=urldecode(thisform.HttpHead1.httpheader)
    
	Private lcType, llFind, lcSeparator, lnArrayRow, laMyArray,lcKey
	Local lcType, llFind, lcSeparator, lnArrayRow, laMyArray[1],lcReturn
    IF thisform.HttpHead1.Content_Type!="application/x-www-form-urlencoded"
		m.lcType = [boundary]
		m.lnArrayRow = Alines(laMyArray, m.tcHttpheader)
	    lcReturn=""
		For m.i = 1 To m.lnArrayRow
		*_screen.Print(m.laMyArray[m.i])
		If [name=] $ laMyArray[m.i]
	        lcKey=Substr(m.laMyArray[m.i], At("name=",m.laMyArray[m.i]) + 6, Len(m.laMyArray[m.i]) - At("name=",m.laMyArray[m.i]) - 6)
		    IF UPPER(lcKey)==upper(_paramkey)
		    *	? [变量值:] + m.laMyArray[m.i+2]
		   	 lcReturn=STRCONV(m.laMyArray[m.i+2],11)
		   	EXIT 
		    ENDIF 
		ENDIF 	
	ENDFOR
	ELSE
	 *--取出后一行
	 LOCAL lnStart,lnLen,lcResult,_cResult
	lnStart=AT(0h0D0A0D0A, tcHttpheader)
    lnLen=LEN(tcHttpheader)
    lcResult=STRCONV(SUBSTR(tcHttpheader,lnStart+4,lnLen-5),11)
    _cResult=""
    *按& 分列成数组
	ALINES(_laarray,lcResult,2,"&")
	FOR i=1 TO alen(_laarray)
	  *--  =号前为key,后为value
	  _nstart=AT("=",_laarray[i])
	  _cKey=SUBSTR(_laarray[i],1,_nstart-1)
	  *_cValue=SUBSTR(laarray[i],_nstart+1,LEN(_laarray[i])-_nstart)
	  IF _cKey==_paramkey
	    _cResult=SUBSTR(_laarray[i],_nstart+1,LEN(_laarray[i])-_nstart)
	  ENDIF 
	NEXT 
      lcReturn=_cResult
	ENDIF 
    RETURN lcReturn
    ENDPROC 
   
    PROCEDURE HttpGetPostData
    LPARAMETERS  _hSocket
   	tcHttpheader=thisform.HttpHead1.httpheader	
   	*STRTOFILE(tcHttpheader,"2.txt")
	Private llFind, lcSeparator, lnArrayRow, laMyArray, lnLength
	Local llFind, lcSeparator, lnArrayRow, laMyArray[1], lnLength,lcResult,lnStart
    lcResult=""
	m.lnArrayRow = Alines(laMyArray, m.tcHttpheader)

	m.lnLength = Len(Strextract(m.laMyArray[1], [/], [HTTP], 1))
	
*!*		For m.i = 1 To m.lnArrayRow
*!*	*!*			If [Content-Length] $ m.laMyArray[m.i]
*!*	*!*				? m.laMyArray[m.i]
*!*	*!*			Endif

*!*	*!*			If [charset=] $ m.laMyArray[m.i]
*!*	*!*				? [charset:] + Substr(m.laMyArray[m.i], At("charset=",m.laMyArray[m.i]) + 8, Len(m.laMyArray[m.i])-At("charset=",m.laMyArray[m.i]) + 8 + 1)
*!*	*!*			Endif

*!*			If m.i > 1 And Empty(m.laMyArray[m.i - 1])
*!*				lcResult= Left(m.laMyArray[m.i], Len(m.laMyArray[m.i]) - m.lnLength)
*!*			ENDIF
*!*			RETURN lcResult
*!*		Endfor 
    lnStart=AT(0h0D0A0D0A, tcHttpheader)
    lnLen=LEN(tcHttpheader)
    lcResult=STRCONV(SUBSTR(tcHttpheader,lnStart+4,lnLen-5),11)
    RETURN lcResult
    ENDPROC 
    
    PROCEDURE Qiyu_Write
       LPARAMETERS _senddata,_hSocket
        LOCAL szHead
                szHead = [HTTP/1.1 200 OK] + 0h0D0A +;
                 [Content-Type: ]+this.contenttype + 0h0D0A+; 
                 [Access-Control-Allow-Origin:*]+ 0h0D0A
                   IF !EMPTY(this.writecookie)
			        szHead = szHead + this._writeHttpHeader+0h0D0A 
			        this._writeHttpHeader=""
			        ENDIF 
			                         
                   IF !EMPTY(this.writecookie)
			        szHead = szHead + this.writecookie
			        this.writecookie=""
			        ENDIF 
                 szHead = szHead +[Content-Length: ] + TRANSFORM(LEN(_senddata)) + 0h0D0A0D0A

        this._SendData(_hSocket, szHead)
        this._SendData(_hSocket, _senddata)
    ENDPROC 
    
    PROCEDURE Qiyu_WriteHeader
       LPARAMETERS _cHeaderKey,_cValue
       LOCAL _szHead
        _szHead=_cHeaderKey+":"+TRANSFORM(_cValue)                 
       this._writeHttpHeader=_szHead
    ENDPROC 
   
   *--待写入的头
   _writeHttpHeader=""
    
   
    writecookie=""  &&待写入的cookie 
    *--还没想好多个Cookie传递
    PROCEDURE Qiyu_WriteCookies
    LPARAMETERS _cHeaderKey,_cValue,_tExpires,_cPath,_cDomain
    LOCAL _parmascount
    _parmascount=PARAMETERS()
    IF _parmascount<3
      ERROR "参数至少三个"
    ENDIF 

      LOCAL _szHead
        _szHead="Set-Cookie:"+_cHeaderKey+"="+TRANSFORM(_cValue) +0h0D0A 
        this.writecookie=_szHead           
       *this._SendData(_hSocket, _szHead)     
      
    ENDPROC 
ENDDEFINE


DEFINE CLASS HttpHead AS Session
    httpheader=""
    Method            = ""
    Url               = ""
    HttpVer           = ""
    
    Authorization     = ""
    Content_Encoding  = ""
    Content_Length    = ""
    Content_Type      = ""
    From              = ""
    If_Modified_Since = ""
    Referer           = ""
    User_Agent        = ""
    Host              = ""
    Auth_Password     = ""
    Auth_Username     = ""
    Auth_Type         = ""
    
    PostData          = ""

    PROCEDURE GetFields(szFields)
        LOCAL szField
        CREATE CURSOR OtherFields (Name C(30), Value C(254))
        ALINES(a_Fields, szFields)
        szField     = a_Fields[ 1 ]
        this.Method = LEFT(szField, AT(" ", szField)-1)
        szField     = STUFF(szField, 1, AT(" ", szField), "")
        this.Url    = LEFT(szField, AT(" HTTP/", szField)-1)
        IF EMPTY(this.Url)
            this.Url = "/"
        ELSE
            IF LEFT(this.Url, 1) != "/"
                this.Url = "/" + this.Url
            ENDIF
        ENDIF
        this.HttpVer = STUFF(szField, 1, AT(" HTTP/", szField)+5, "")
        FOR i = 2 TO ALEN(a_Fields)
            szField = a_Fields[ i ]
            IF EMPTY(szField)    && end of header is 0h0D0A0D0A
                EXIT
            ENDIF
            INSERT INTO OtherFields VALUES (LEFT(szField, AT(":", szField)-1),;
                                            LTRIM(STUFF(szField, 1, AT(":", szField), "")))
        ENDFOR
        this.Authorization     = this.GetOtherFields("Authorization")
        this.Content_Encoding  = this.GetOtherFields("Content-Encoding")
        this.Content_Length    = this.GetOtherFields("Content-Length")
        this.Content_Type      = this.GetOtherFields("Content-Type")
        this.From              = this.GetOtherFields("From")
        this.If_Modified_Since = this.GetOtherFields("If-Modified-Since")
        this.Referer           = this.GetOtherFields("Referer")
        this.User_Agent        = this.GetOtherFields("User-Agent")
        this.Host              = this.GetOtherFields("Host")
        this.Auth_Password     = this.Authorization
        this.Auth_Type         = LEFT(this.Auth_Password, AT(" ", this.Auth_Password)-1)
        this.Auth_Password     = STUFF(this.Auth_Password, 1, AT(" ", this.Auth_Password), "")
        this.Auth_Password     = STRCONV(this.Auth_Password, 14)    && base64 编码数据转换
        this.Auth_Username     = LEFT(this.Auth_Password, AT(":", this.Auth_Password)-1)
        this.Auth_Password     = STUFF(this.Auth_Password, 1, AT(":", this.Auth_Password), "")
        *USE IN "OtherFields"
    ENDPROC

    FUNCTION GetOtherFields(szName)
        SELECT OtherFields
        LOCATE FOR UPPER(ALLTRIM(Name)) == UPPER(szName)
        RETURN ALLTRIM(Value)
    ENDFUNC
ENDDEFINE


*调试信息
FUNCTION _WriteFields(oHttpHead)
    RETURN "************" + 0h0D0A +;
           "Method.............." + oHttpHead.Method + 0h0D0A +;
           "Url................." + oHttpHead.Url + 0h0D0A +;
           "HttpVer............." + oHttpHead.HttpVer + 0h0D0A +;
           "Authorization......." + oHttpHead.Authorization + 0h0D0A +;
           "Content_Encoding...." + oHttpHead.Content_Encoding + 0h0D0A +;
           "Content_Length......" + oHttpHead.Content_Length + 0h0D0A +;
           "Content_Type........" + oHttpHead.Content_Type + 0h0D0A +;
           "From................" + oHttpHead.From + 0h0D0A +;
           "If_Modified_Since..." + oHttpHead.If_Modified_Since + 0h0D0A +;
           "Referer............." + oHttpHead.Referer + 0h0D0A +;
           "User_Agent.........." + oHttpHead.User_Agent + 0h0D0A +;
           "Host................" + oHttpHead.Host + 0h0D0A +;
           "Auth_Password......." + oHttpHead.Auth_Password + 0h0D0A +;
           "Auth_Username......." + oHttpHead.Auth_Username + 0h0D0A +;
           "Auth_Type..........." + oHttpHead.Auth_Type
ENDFUNC


FUNCTION _OnError(nErrNum, szErrMsg, szErrCode, szErrProgram, nErrLineNo)
    LOCAL szMsg, nRet
    
    szMsg = '错误信息: ' + szErrMsg           + 0h0D0D;
          + '错误编号: ' + TRANSFORM(nErrNum) + 0h0D0D;
          + '错误代码: ' + szErrCode          + 0h0D0D;
          + '出错程序: ' + szErrProgram       + 0h0D0D;
          + '出错行号: ' + TRANSFORM(nErrLineNo)

    nRet = MESSAGEBOX(szMsg, 2+48+512, "Error")

    DO CASE
    CASE nRet == 3            && 终止
        CANCEL
    CASE nRet == 4            && 重试
        RETRY
    ENDCASE
ENDFUNC
