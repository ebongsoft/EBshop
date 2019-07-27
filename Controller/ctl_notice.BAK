*系统错误
*?state=1&orderNum=006&txamt=000000000001&attach=&goodsInfo=&errDetail=validate%20signature%20error&outOrderNum=&transTime=2019-05-30%2021:29:03
*支付情况
*?errorDetail=%E6%88%90%E5%8A%9F&orderNum=20190530234330&state=0&transTime=2019-05-30%2023%3A43%3A38&txamt=000000000001
Define Class ctl_notice As Session
*-- 用于前台支付与否跳转
	Procedure onDefault
*-- 可以返回制作好的HTML
*-- cReturnHtml=FILETOSTR("1.html")
	cFile=getwwwrootpath("")  +"paysuccessful.html"
	chTML=Filetostr(cFile)
*cReturnHtml=FILETOSTR("paysuccessful.html") && 支付完成
	orderNum=HttpQueryParams("orderNum")
	errDetail=HttpQueryParams("errDetail")
	errorDetail=HttpQueryParams("errorDetail")
* ?errorDetail
	cResult=""
	If !Empty(errorDetail)
		If errorDetail=="成功"
			cResult=""
		Else
			cResult=errorDetail
		Endif
	Else
		If !Empty(errDetail)
			cResult=errDetail
		Endif
	Endif
	If !Empty(cResult)
		Return "orderNO:"+orderNum+cResult  && 有ERROR
	Else
		Return chTML
	Endif
	
	Endproc

Enddefine




