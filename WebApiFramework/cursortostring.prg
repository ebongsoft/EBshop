*-- 不能直接使用JSON传递，为了兼容性采用BASE64转码，体积增加3分之一
Function CursorToBASE64
Lparameters tablename,ntotoal
Local lncount,lcResult,cmyData
*!*	Set Library To foxjson.Fll  Additive
*!*	Set Procedure To foxjson Additive
*!*	SET Library TO myfll ADDITIVE
If !Used(tablename)
	Error tablename+"没有被打开"
Endif
oldtable=Select()
Select (tablename)
Count To lncount
oData=Createobject("foxJson")
oData.Append("Data","<<cmyData>>")
If Pcount()>1
	oData.Append("total",Ceiling(ntotoal))
Else
	oData.Append("total",lncount)
Endif
oData.Append("count",lncount)
oData.Append("errno",0)
oData.Append("errmsg","ok")
cmyData=Strconv(cursortostr(tablename),13)
oData.Append(Data,cmyData)

*!*	TEXT TO lcResult NOSHOW TEXTMERGE
*!*	{ "total": <<lncount>>, "count": <<lncount>>,  "errno": 0, "errmsg": "ok" }
*!*	ENDTEXT
Select (oldtable)
Return oData.ToString()
Endproc



