*--兼容猫框调试服务器和木瓜的fws.dll
Function HttpQueryParams
Lparameters cParam1,iConnid
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&调试环境
    *Set Library To HttpServer.Fll Additive &&设置外部库文件，这样才能调用此FLL里的函数功能
	*cResult=HttpGetQueryString(cParam1)
	*cResult=Qiyu_Request(iConnid,cParam1)
	cResult=oFrmMain.SocketHttp1.Qiyu_Request(STRCONV(cParam1,9),iConnid)	
	If Empty(cResult)
		*cResult=HttpGetFormString(cParam1)		
		cResult=oFrmMain.SocketHttp1.Qiyu_FormParams(cParam1,iConnid)		
	ENDIF
	cResult=STRCONV(cResult,11)
Else
	*cResult=fws_request(urlencode(STRCONV(cParam1,9))) &&正式环境 首先URL编码,再UTF解码
	cResult=fws_request(cParam1) &&正式环境 首先URL编码,再UTF解码
Endif
Return cResult
Endfunc


Function HttpGetPostData
Lparameters m.iConnID
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&调试环境
	cResult=oFrmMain.SocketHttp1.HttpGetPostData(m.iConnID)
Else
	cResult=fws_binread() &&正式环境
	cResult=STRCONV(cResult,11)
Endif

Return cResult
Endproc


Function HttpResponseWrite
Lparameters cParam1,iConnid
If Inlist(_vfp.StartMode,0) &&调试环境
	oFrmMain.SocketHttp1.Qiyu_Write(STRCONV(cParam1,9),iConnid)	
Else
	fws_write(m.cParam1) &&正式环境
Endif
Endfunc

*--向客户端得到Cookie
*--兼容木瓜的fws.dll
Function Httpgetcookie
Lparameters cCookiename,iConnid
*tExpires,cPath,cDomain 暂未处理
Local cResult,cTmp,laarry
cResult=""
If Inlist(_vfp.StartMode,0) &&调试环境
	cTmp=ofrmmain.httPHEAD1.getotherfields("Cookie")
	DIMENSION laarry[1]
	ALINES(laarry,cTmp,";","=")
	FOR i=1 TO ALEN(laarry) STEP 2	 
	  IF ALLTRIM(cCookiename)==ALLTRIM(laarry[i])
	    cResult=laarry[i+1]
	    EXIT 
	  ENDIF 
	NEXT 	
	cResult=STRCONV(cResult,11)
Else
	cResult=fws_Cookies(cCookiename)  &&正式环境
ENDIF
RETURN cResult
ENDFUNC

*--向客户端写入Cookie
*--兼木瓜的fws.dll
*-- cookie名，值，超时时间，路径，域名
Function Httpsetcookie
Lparameters cCookieValue,ckeyvalue,tExprietime,cPath,cDomain,iConnid
*tExpires,cPath,cDomain 暂未处理
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&调试环境
     oFrmMain.SocketHttp1.Qiyu_WriteCookies(STRCONV(cCookieValue,9),STRCONV(ckeyvalue,9),tExprietime)
Else
	fws_Cookies(cCookieValue,ckeyvalue,tExprietime)  &&正式环境
Endif
Endfunc

*-- 得到上传文件
Function GetPostDataObj(iConnID)
Local cData, oData, i, cParseChar, nFieldCnt, cFieldHead, cFieldData, cFieldName
Dimension aForm(1)

m.cData = oFrmMain.SocketHttp1.HttpGetPostData(m.iConnID)
m.oData = Createobject("Collection")
m.oData.AddProperty("RawData", m.cData)
m.oData.AddProperty("FieldType", Createobject("Collection"))
m.oData.AddProperty("FieldFileName", Createobject("Collection"))

If Not Empty(m.cData)
	m.cParseChar = Strextract(m.cData, "", Chr(13))
	m.nFieldCnt = Alines(aForm, m.cData, 4, m.cParseChar) - 1
	For i = 1 To m.nFieldCnt
	    nStart=AT(CHR(13)+CHR(10),aForm(i),4)
		m.cFieldHead=LEFT(aForm(i),nStart)
		m.cFieldData =Right(aForm(1),len(aform(i))-nStart-1)
		m.cFieldName = Strextract(m.cFieldHead, [name="], ["]) &&字段名 name="photo" 之类的
		oData.Add(m.cFieldData, m.cFieldName)
		oData.FieldType.Add(Alltrim(Strextract(m.cFieldHead, [Content-Type:], [])), m.cFieldName)  &&文件类型
		oData.FieldFileName.Add(Justfname(Strextract(m.cFieldHead, [filename="], ["])), m.cFieldName) &&文件名
	Next
Endif

*!*	If Not Empty(m.cData)
*!*		m.cParseChar = Strextract(m.cData, "", Chr(13))
*!*		m.nFieldCnt = Alines(aForm, m.cData, 4, m.cParseChar) - 1
*!*		For i = 1 To m.nFieldCnt
*!*			m.cFieldHead = Strextract(aForm(i), Chr(13) + Chr(10), Chr(13) + Chr(10) + Chr(13) + Chr(10), 1, 4)
*!*			m.cFieldData = Strextract(aForm(i), m.cFieldHead, Chr(13))
*!*			m.cFieldData = Left(m.cFieldData, Len(m.cFieldData) - 2)
*!*			m.cFieldName = Strextract(m.cFieldHead, [name="], ["])
*!*			oData.Add(m.cFieldData, m.cFieldName)
*!*			oData.FieldType.Add(Alltrim(Strextract(m.cFieldHead, [Content-Type:], [])), m.cFieldName)
*!*			oData.FieldFileName.Add(Justfname(Strextract(m.cFieldHead, [filename="], ["])), m.cFieldName)
*!*		Next
*!*	Endif
Return m.oData
Endfunc
*-- 近回POST 或GET
FUNCTION getMethod()
   Local cResult
   cResult=""
   If Inlist(_vfp.StartMode,0) &&调试环境
      cResult=ofrmmain.httPHEAD1.mETHOD
   ELSE
     cResult=fws_header("REQUEST_METHOD") &&正式环境
   ENDIF 
   RETURN cResult
ENDPROC 

*-- URL 转向
*-- 兼容木瓜的fws.dll
Function HttpRedirect
Lparameters cUrl,iConnid
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&调试环境
    cResult=oFrmMain.SocketHttp1._HttpRedirect(cUrl,iConnid)
Else
	cResult=fws_Redirect(cUrl) &&正式环境 URL跳转
Endif
Return cResult
Endfunc

*--将文件目录转换为wwwroot目录
Function  GetWWWRootPath
	Lparameters cPath
	Return Iif(_vfp.StartMode==0,ADDBS("wwwroot\"+cPath),ADDBS(cPath))
Endfunc


*-- 得到上传文件
*-- 1 先取出完整头部 取出分割符
*-- 2 根据分割符,取出数据体
Function GetUpFile(iConnID)
	Local cData, oData, i, cParseChar, nFieldCnt, cFieldHead, cFieldData, cFieldName,oResult,oData ,oField,FileName
	LOCAL cMylen,cPostBody,cPostHeader,nStart
	Dimension aForm(1)	
    oResult=CREATEOBJECT("empty")
	AddProperty(oResult,"RawData", m.cData)  &&原始数据	
	m.oData = Createobject("Collection")
	IF _vfp.StartMode==0	
	    m.cData=oFrmMain.HttpHead1.httpheader
	    *--得以文件头
	    nStart=AT(0h0D0A0D0A,m.cData)
	    cPostHeader=LEFT(m.cData,nStart)
	    m.cParseChar = "--"+Strextract(m.cPostHeader, "boundary=", CHR(13)) &&取出分割符
	    *?"boundary",cParseChar 
	    cMylen=Strextract(UPPER(m.cPostHeader), UPPER("Content-Length:"), CHR(13)) &&取得Content-Length
		*?"Content-Length-",cMylen
	    cPostBody=RIGHT(cData,LEN(cData)-nStart+1-4) &&除掉0h0D0A0D0A
    ELSE
        m.cParseChar=fws_header(UPPER("Content-Type"))       
        cMylen=fws_header(UPPER("HTTP_CONTENT_LENGTH"))
        cPostBody=fws_binread()        
        oFrmMain.log("ff1"+m.cParseChar+cMylen)    
        m.cParseChar = Strextract(cPostBody, "", Chr(13))        
        oFrmMain.log("ff"+m.cParseChar+cMylen)       
        oFrmMain.log( fws_GetAllHeader())
    ENDIF 
    *STRTOFILE(cPostBody,"data1.txt")
	If Not Empty(cPostBody)					
		m.nFieldCnt = Alines(aForm, m.cPostBody, 4, m.cParseChar+0h0d0a)	&&大于1说明一定有分割符
		For i = 1 To m.nFieldCnt
			*nStart=At(Chr(13)+Chr(10),aForm(i),4)					   
			    STRTOFILE(aForm[i],"data.txt")
				nStart=AT(0h0D0A0D0A,aForm[i],1)  &&两个换行符后是真正的数据
				*?"nstart",nStart
				m.cFieldHead=Left(aForm(i),nStart)  &&取出字段头部
				*?"cFieldHead",cFieldHead
				*--name名
				m.cFieldName =Strextract(m.cFieldHead, [name="], ["]) &&字段名 name="photo" 之类的			
				m.cFieldName =STRCONV(m.cFieldName,11)			
				*--原始文件名
				m.FileName=Justfname(Strextract(m.cFieldHead, [filename="], ["]))
				m.FileName=STRCONV(m.FileName,11)	
		     					
				oField=CREATEOBJECT("empty")			
				AddProperty(oField,"FieldType",Alltrim(Strextract(m.cFieldHead, [Content-Type:], [])))		
				ADDPROPERTY(oField,"FieldName",m.cFieldName ) &&字段名				
				ADDPROPERTY(oField,"Disposition",Strextract(m.cFieldHead, [Content-Disposition:], [;]))
								
				****文件 或变量值
				IF !Empty(Strextract(m.cFieldHead, [Content-Type:], []))  &&文件
				    ADDPROPERTY(oField,"FileName",FileName) &&文件名
					LOCAL nEnd
					nEnd=RAT(m.cParseChar,aForm(i)) &&求出最后分割符的侠置				
					m.cFieldData =substr(aForm(i),nStart+4,nEnd-nStart-4-2)  &&数据
					*?Len(cFieldData),nStart-3,Len(aform(i)),nEnd
	                ADDPROPERTY(oField,"FieldData",m.cFieldData) &&数据
					STRTOFILE(cFieldData,"xx.jpg")	
					m.oData.add(oField,m.cFieldName)
			   ELSE  
					LOCAL nEnd
					nEnd=len(aForm(i)) &&求出最后分割符的侠置				
					m.cFieldData =substr(aForm(i),nStart+4,nEnd-nStart-4)  &&数据
					*?Len(cFieldData),nStart-3,Len(aform(i)),nEnd
	                ADDPROPERTY(oField,"FieldData",m.cFieldData) &&数据
					*STRTOFILE(cFieldData,"xx.jpg")	
					m.oData.add(oField,m.cFieldName)			   
			   ENDIF 
			
		Next
        ADDPROPERTY(oResult,"oFieldColl",oData)   
	ENDIF
	*?oResult.oFieldColl.item(1).FieldType
	*?oResult.oFieldColl.item(1).FileName
	*?oResult.oFieldColl.item(1).FieldName
	Return m.oResult
Endfunc
