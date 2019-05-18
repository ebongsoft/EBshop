Function CursorToJson
Lparameters tablename,ntotoal
Set Library To foxjson.Fll  Additive
Set Procedure To foxjson Additive
SET Library TO myfll ADDITIVE 
If !Used(tablename)
	Error tablename+"没有被打开"
Endif
oRows=Createobject("foxJson",{})
oldtable=Select()
Select (tablename)
Scan
	oJson=Createobject("foxJson")
	For i =1 To Fcount()
		cField=LOWER(Field(i))  
 		DO CASE 
 		 CASE  VARTYPE(&cField)=='C'
		  uVal=transform(&cField,'@T')
		 CASE  VARTYPE(&cField)=='G'
		  uVal=''
		 CASE  VARTYPE(&cField)=='T'
		  uVal=TTOC(&cField)	  
		 OTHERWISE 
		  uVal=&cField
		ENDCASE 
		oJson.Append(cField,uVal)
	Next
	oRows.Append(oJson)
Endscan
**再把数组和行组合
*brow
oData=Createobject("foxJson")
If Pcount()>1
	oData.Append("total",CEILING(ntotoal))
Else
	oData.Append("total",oRows.Count)
ENDIF
oData.Append("count",oRows.Count)
oData.Append("rows",oRows)
oData.Append("errno",0)
oData.Append("errmsg","ok")
Select (oldtable)
Return oData.tostring()
Endproc



