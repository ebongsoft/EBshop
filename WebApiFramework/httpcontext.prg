*-- 一个获取头部信息的类
Define Class  HttpContext As Custom
	Procedure getAbsoluteUri
		Local cAbsoluteuri,cServername,cPort,cPATH_INFO,cQUERY_STRING
		cAbsoluteuri=""

		If Inlist(_vfp.StartMode,0) &&调试环境
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

	&&微信用 去端口
	Procedure getWxRedirect_uri
		Local cAbsoluteuri,cServername,cPort,cPATH_INFO,cQUERY_STRING,lnMh
		cAbsoluteuri=""
		If Inlist(_vfp.StartMode,0) &&调试环境
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
		*QyWritelog("路径"+cAbsoluteuri)  &&写入日志

		Return cAbsoluteuri
	Endproc
Enddefine

