Clear
oQiyuJson=Createobject("QiyuJson")
oQiyuJson.Append("name","123")
oQiyuJson.appendcursor("cpkc",10)
oQiyuJson.appendcursor("cpkc2",10)
?oQiyuJson.ToJSON()
_cliptext=oQiyuJson.ToJSON()
*-- 单纯的键值对 append(键,值) 输出 {键,值}
*-- 单纯的键值对 append(键,值) 输出 {键,值}

Define Class QiyuJson As Custom
	oColl=.F.
	oCursor=.F.
	oObj=.f.
	Procedure Init
		This.oColl=Createobject("collection")
		This.oCursor=Createobject("collection")
		This.oObj=Createobject("collection")
	Endproc


	*--添加键值对
	Procedure Append
		Lparameters cKey,cValue
		This.oColl.Add(cValue,cKey)
	Endproc
	
	*-- 添加表转换对象
	Procedure AppendCursorToObj
		Lparameters ctablename,cAlias
		If !Used(ctablename)
			Error "表没有被打开"
		Endif

		oFly=Createobject("empty")
		AddProperty(oFly,"tablename",ctablename)
		AddProperty(oFly,"alias",IIF(EMPTY(cAlias),ctablename,calias))	
		This.oObj.Add(oFly,ctablename)
	endproc
	
	
	*--添加表
	Procedure AppendCursor
		Lparameters ctablename,nTotal,cAlias
		If !Used(ctablename)
			Error "表没有被打开"
		Endif
		If Empty(nTotal) 
			Select Count(*) From &ctablename Into Array xxy
			nTotal=xxy    &&直接获取表的长度
		ELSE
		  if VARTYPE(nTotal)!="N"
		    ERROR "请传入数值型"	
		  ENDIF 
		Endif
        
        
		oFly=Createobject("empty")
		AddProperty(oFly,"tablename",ctablename)
		AddProperty(oFly,"alias",IIF(EMPTY(cAlias),ctablename,calias))
		AddProperty(oFly,"nTotal",nTotal)
		This.oCursor.Add(oFly,ctablename)
	Endproc

	*-- 1 简单模式 单表结构直接放 rows:[{}],多表 {表名1:[{}],表名2}
	*-- 2 带errno,errmsg模式 ,单表结构直接放 rows:[{}],多表 {表名1:[{}],表名2}  默认

	Procedure ToJson
		Lparameters nParam
		Local oObject,oRows,oTable		
		oObject=Createobject("foxJson")
		If Empty(nParam)
			nParam=2
		Endif
		Do Case
		Case nParam=1

		Case nParam=2
			oObject.Append("errno",0)
			oObject.Append("errmsg","ok")
			oObject.Append("success",.t.)
		Otherwise
			Error "参数不正确"
		Endcase
		*--首先添加oColl
		*--无没有Total  &&单表情况,多表情况的total
		istotal=.F.
		For i=1 To This.oColl.Count
			oObject.Append(This.oColl.GetKey(i),This.oColl.Item(i))
			*!*				If(This.oColl.GetKey(i)=="total") &&key值total
			*!*					istotal=T.
			*!*				Endif
			*?"ff",This.oColl.Item(i)
		NEXT
		*--开始添加对象
		For i=1 To This.oObj.Count				
				*oldtable=Select()
				ctablename=This.oObj.Item(i).tablename
				Select (ctablename)	
				oJson=Createobject("foxJson")
				For j =1 To Fcount()
					cField=Lower(Field(j))
					Do Case
					Case  Vartype(&cField)=='C'
						If Type("&cField")=="C"
							uVal=Transform(&cField,'@T')
						Else
							uVal=ALLTRIM(&cField)
						Endif
					Case  Vartype(&cField)=='G'
						uVal=''
					Otherwise
						uVal=&cField
					Endcase
					oJson.Append(cField,uVal)						
				Next				
				oObject.Append(This.oObj.Item(i).alias,oJson)
		Next		
		
		*--开始添加表
		Do Case
		Case This.oCursor.Count=1		
			oRows=Createobject("foxJson",{})
			*oldtable=Select()
			ctablename=This.oCursor.Item(1).tablename
			Select (ctablename)	
			SCAN			   
				oJson=Createobject("foxJson")
				For i =1 To Fcount()
					cField=Lower(Field(i))
					Do Case
					Case  Vartype(&cField)=='C'
							If Type("&cField")=="C"
								uVal=Transform(&cField,'@T')
							Else
								uVal=ALLTRIM(&cField)
							Endif
					Case  Vartype(&cField)=='G'
						uVal=''
					Otherwise
						uVal=&cField
					Endcase
					oJson.Append(cField,uVal)
				Next
				oRows.Append(oJson)
			Endscan
			*If(!istotal)
			oObject.Append("total",INT(This.oCursor.Item(1).ntotal))
			*Endif
			oObject.Append("count",oRows.Count)
			oObject.Append("rows",oRows)

		Case This.oCursor.Count>1
			For i=1 To This.oCursor.Count				
				*oldtable=Select()
				ctablename=This.oCursor.Item(i).tablename
				*?ctablename,This.oCursor.Item(i).ntotal
				Select (ctablename)
				oTable=Createobject("foxJson")
				oRows=Createobject("foxJson",{})
				Scan
					oJson=Createobject("foxJson")
					For j =1 To Fcount()
						cField=Lower(Field(j))
						Do Case
						Case  Vartype(&cField)=='C'
							If Type("&cField")=="C"
								uVal=Transform(&cField,'@T')
							Else
								uVal=ALLTRIM(&cField)
							Endif
						Case  Vartype(&cField)=='G'
							uVal=''
						Otherwise
							uVal=&cField
						Endcase
						oJson.Append(cField,uVal)						
					Next
					oRows.Append(oJson)					
				Endscan
				oTable.Append("total",INT(This.oCursor.Item(i).ntotal))
				oTable.Append("count",oRows.Count)
				oTable.append("rows",oRows)
				oObject.Append(This.oCursor.Item(i).alias,oTable)
			Next
            
		Endcase

		Return oObject.ToString()

	Endproc
Enddefine
