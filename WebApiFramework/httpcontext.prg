*-- һ����ȡͷ����Ϣ����
Define Class  HttpContext As Custom
	Procedure getAbsoluteUri
		Local cAbsoluteuri,cServername,cPort,cPATH_INFO,cQUERY_STRING
		cAbsoluteuri=""

		If Inlist(_vfp.StartMode,0) &&���Ի���
			cServername= oFrmMain.HttpHead1.Host
			cAbsoluteuri ="http://"+cServername+oFrmMain.HttpHead1.Url
		Else
			cServername=fws_header("SERVER_NAME")
			cPort=fws_header("SERVER_PORT")
			cPATH_INFO=fws_header("PATH_INFO")
			cQUERY_STRING=fws_header("QUERY_STRING")

			TEXT TO cAbsoluteuri NOSHOW TEXTMERGE PRETEXT 1+2
  http://<<cServername>>:<<cPort>><<cPATH_INFO>>?<<cQUERY_STRING>>
			ENDTEXT
		Endif
		Return cAbsoluteuri
	Endproc

	&&΢���� ȥ�˿�
	Procedure getWxRedirect_uri
		Local cAbsoluteuri,cServername,cPort,cPATH_INFO,cQUERY_STRING,lnMh
		cAbsoluteuri=""
		If Inlist(_vfp.StartMode,0) &&���Ի���
			cServername= oFrmMain.HttpHead1.Host
			lnMh=At(":",cServername)
			If(lnMh>0)
				cServername=Left(cServername,lnMh-1)
			Endif
			cAbsoluteuri ="http://"+cServername+oFrmMain.HttpHead1.Url
		Else
			cServername=fws_header("SERVER_NAME")
			cPort=fws_header("SERVER_PORT")
			cPATH_INFO=fws_header("PATH_INFO")
			cQUERY_STRING=fws_header("QUERY_STRING")
			TEXT TO cAbsoluteuri NOSHOW TEXTMERGE PRETEXT 1+2
    http://<<cServername>><<cPATH_INFO>>?<<cQUERY_STRING>>
			ENDTEXT
		Endif
		*QyWritelog("·��"+cAbsoluteuri)  &&д����־

		Return cAbsoluteuri
	Endproc
Enddefine

