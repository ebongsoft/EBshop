*ϵͳ����
*?state=1&orderNum=006&txamt=000000000001&attach=&goodsInfo=&errDetail=validate%20signature%20error&outOrderNum=&transTime=2019-05-30%2021:29:03
*֧�����
*?errorDetail=%E6%88%90%E5%8A%9F&orderNum=20190530234330&state=0&transTime=2019-05-30%2023%3A43%3A38&txamt=000000000001
Define Class ctl_notice As Session
*-- ����ǰ̨֧�������ת
	Procedure onDefault
*-- ���Է��������õ�HTML
*-- cReturnHtml=FILETOSTR("1.html")
	cFile=getwwwrootpath("")  +"paysuccessful.html"
	chTML=Filetostr(cFile)
*cReturnHtml=FILETOSTR("paysuccessful.html") && ֧�����
	orderNum=HttpQueryParams("orderNum")
	errDetail=HttpQueryParams("errDetail")
	errorDetail=HttpQueryParams("errorDetail")
* ?errorDetail
	cResult=""
	If !Empty(errorDetail)
		If errorDetail=="�ɹ�"
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
		Return "orderNO:"+orderNum+cResult  && ��ERROR
	Else
		Return chTML
	Endif
	
	Endproc

Enddefine




