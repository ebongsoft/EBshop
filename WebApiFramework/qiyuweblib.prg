*--����è����Է�������ľ�ϵ�fws.dll
Function HttpQueryParams
Lparameters cParam1,iConnid
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&���Ի���
    *Set Library To HttpServer.Fll Additive &&�����ⲿ���ļ����������ܵ��ô�FLL��ĺ�������
	*cResult=HttpGetQueryString(cParam1)
	*cResult=Qiyu_Request(iConnid,cParam1)
	cResult=oFrmMain.SocketHttp1.Qiyu_Request(STRCONV(cParam1,9),iConnid)	
	If Empty(cResult)
		*cResult=HttpGetFormString(cParam1)		
		cResult=oFrmMain.SocketHttp1.Qiyu_FormParams(cParam1,iConnid)		
	ENDIF
	cResult=STRCONV(cResult,11)
Else
	*cResult=fws_request(urlencode(STRCONV(cParam1,9))) &&��ʽ���� ����URL����,��UTF����
	cResult=fws_request(cParam1) &&��ʽ���� ����URL����,��UTF����
Endif
Return cResult
Endfunc


Function HttpGetPostData
Lparameters m.iConnID
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&���Ի���
	cResult=oFrmMain.SocketHttp1.HttpGetPostData(m.iConnID)
Else
	cResult=fws_binread() &&��ʽ����
	cResult=STRCONV(cResult,11)
Endif

Return cResult
Endproc


Function HttpResponseWrite
Lparameters cParam1,iConnid
If Inlist(_vfp.StartMode,0) &&���Ի���
	oFrmMain.SocketHttp1.Qiyu_Write(STRCONV(cParam1,9),iConnid)	
Else
	fws_write(m.cParam1) &&��ʽ����
Endif
Endfunc

*--��ͻ��˵õ�Cookie
*--����ľ�ϵ�fws.dll
Function Httpgetcookie
Lparameters cCookiename,iConnid
*tExpires,cPath,cDomain ��δ����
Local cResult,cTmp,laarry
cResult=""
If Inlist(_vfp.StartMode,0) &&���Ի���
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
	cResult=fws_Cookies(cCookiename)  &&��ʽ����
ENDIF
RETURN cResult
ENDFUNC

*--��ͻ���д��Cookie
*--��ľ�ϵ�fws.dll
*-- cookie����ֵ����ʱʱ�䣬·��������
Function Httpsetcookie
Lparameters cCookieValue,ckeyvalue,tExprietime,cPath,cDomain,iConnid
*tExpires,cPath,cDomain ��δ����
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&���Ի���
     oFrmMain.SocketHttp1.Qiyu_WriteCookies(STRCONV(cCookieValue,9),STRCONV(ckeyvalue,9),tExprietime)
Else
	fws_Cookies(cCookieValue,ckeyvalue,tExprietime)  &&��ʽ����
Endif
Endfunc

*-- �õ��ϴ��ļ�
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
		m.cFieldName = Strextract(m.cFieldHead, [name="], ["]) &&�ֶ��� name="photo" ֮���
		oData.Add(m.cFieldData, m.cFieldName)
		oData.FieldType.Add(Alltrim(Strextract(m.cFieldHead, [Content-Type:], [])), m.cFieldName)  &&�ļ�����
		oData.FieldFileName.Add(Justfname(Strextract(m.cFieldHead, [filename="], ["])), m.cFieldName) &&�ļ���
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
*-- ����POST ��GET
FUNCTION getMethod()
   Local cResult
   cResult=""
   If Inlist(_vfp.StartMode,0) &&���Ի���
      cResult=ofrmmain.httPHEAD1.mETHOD
   ELSE
     cResult=fws_header("REQUEST_METHOD") &&��ʽ����
   ENDIF 
   RETURN cResult
ENDPROC 

*-- URL ת��
*-- ����ľ�ϵ�fws.dll
Function HttpRedirect
Lparameters cUrl,iConnid
Local cResult
cResult=""
If Inlist(_vfp.StartMode,0) &&���Ի���
    cResult=oFrmMain.SocketHttp1._HttpRedirect(cUrl,iConnid)
Else
	cResult=fws_Redirect(cUrl) &&��ʽ���� URL��ת
Endif
Return cResult
Endfunc

*--���ļ�Ŀ¼ת��ΪwwwrootĿ¼
Function  GetWWWRootPath
	Lparameters cPath
	Return Iif(_vfp.StartMode==0,ADDBS("wwwroot\"+cPath),ADDBS(cPath))
Endfunc


*-- �õ��ϴ��ļ�
*-- 1 ��ȡ������ͷ�� ȡ���ָ��
*-- 2 ���ݷָ��,ȡ��������
Function GetUpFile(iConnID)
	Local cData, oData, i, cParseChar, nFieldCnt, cFieldHead, cFieldData, cFieldName,oResult,oData ,oField,FileName
	LOCAL cMylen,cPostBody,cPostHeader,nStart
	Dimension aForm(1)	
    oResult=CREATEOBJECT("empty")
	AddProperty(oResult,"RawData", m.cData)  &&ԭʼ����	
	m.oData = Createobject("Collection")
	IF _vfp.StartMode==0	
	    m.cData=oFrmMain.HttpHead1.httpheader
	    *--�����ļ�ͷ
	    nStart=AT(0h0D0A0D0A,m.cData)
	    cPostHeader=LEFT(m.cData,nStart)
	    m.cParseChar = "--"+Strextract(m.cPostHeader, "boundary=", CHR(13)) &&ȡ���ָ��
	    *?"boundary",cParseChar 
	    cMylen=Strextract(UPPER(m.cPostHeader), UPPER("Content-Length:"), CHR(13)) &&ȡ��Content-Length
		*?"Content-Length-",cMylen
	    cPostBody=RIGHT(cData,LEN(cData)-nStart+1-4) &&����0h0D0A0D0A
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
		m.nFieldCnt = Alines(aForm, m.cPostBody, 4, m.cParseChar+0h0d0a)	&&����1˵��һ���зָ��
		For i = 1 To m.nFieldCnt
			*nStart=At(Chr(13)+Chr(10),aForm(i),4)					   
			    STRTOFILE(aForm[i],"data.txt")
				nStart=AT(0h0D0A0D0A,aForm[i],1)  &&�������з���������������
				*?"nstart",nStart
				m.cFieldHead=Left(aForm(i),nStart)  &&ȡ���ֶ�ͷ��
				*?"cFieldHead",cFieldHead
				*--name��
				m.cFieldName =Strextract(m.cFieldHead, [name="], ["]) &&�ֶ��� name="photo" ֮���			
				m.cFieldName =STRCONV(m.cFieldName,11)			
				*--ԭʼ�ļ���
				m.FileName=Justfname(Strextract(m.cFieldHead, [filename="], ["]))
				m.FileName=STRCONV(m.FileName,11)	
		     					
				oField=CREATEOBJECT("empty")			
				AddProperty(oField,"FieldType",Alltrim(Strextract(m.cFieldHead, [Content-Type:], [])))		
				ADDPROPERTY(oField,"FieldName",m.cFieldName ) &&�ֶ���				
				ADDPROPERTY(oField,"Disposition",Strextract(m.cFieldHead, [Content-Disposition:], [;]))
								
				****�ļ� �����ֵ
				IF !Empty(Strextract(m.cFieldHead, [Content-Type:], []))  &&�ļ�
				    ADDPROPERTY(oField,"FileName",FileName) &&�ļ���
					LOCAL nEnd
					nEnd=RAT(m.cParseChar,aForm(i)) &&������ָ��������				
					m.cFieldData =substr(aForm(i),nStart+4,nEnd-nStart-4-2)  &&����
					*?Len(cFieldData),nStart-3,Len(aform(i)),nEnd
	                ADDPROPERTY(oField,"FieldData",m.cFieldData) &&����
					STRTOFILE(cFieldData,"xx.jpg")	
					m.oData.add(oField,m.cFieldName)
			   ELSE  
					LOCAL nEnd
					nEnd=len(aForm(i)) &&������ָ��������				
					m.cFieldData =substr(aForm(i),nStart+4,nEnd-nStart-4)  &&����
					*?Len(cFieldData),nStart-3,Len(aform(i)),nEnd
	                ADDPROPERTY(oField,"FieldData",m.cFieldData) &&����
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
