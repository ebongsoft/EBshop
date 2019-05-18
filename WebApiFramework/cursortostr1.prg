Function CursorToStr1
Lparameters tablename,ntotoal
LOCAL lncount
Set Library To foxjson.Fll  Additive
Set Procedure To foxjson Additive
Set Library To myfll Additive

WAIT tablename window
If !Used(tablename)
	Error tablename+"没有被打开"
Endif
oRows=Createobject("foxJson",{})
SELECT (tablename)
COUNT TO lncount
oData.Append("Data",CursorToStr("tablename"))
*brow
oData=Createobject("foxJson")
If Pcount()>1
	oData.Append("total",Ceiling(ntotoal))
Else
	oData.Append("total",lncount)
Endif
oData.Append("count",oRows.Count)
oData.Append("rows",oRows)
oData.Append("errno",0)
oData.Append("errmsg","ok")
Select (oldtable)
Return oData.tostring()
Endproc


