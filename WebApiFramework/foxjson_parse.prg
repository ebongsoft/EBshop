*!*	* json parse
*!*	* return a collection
*!*	oJson=foxJson_Parse('{"name":"lee","age":32, "childs":[{"name":"xiao ming","age":2},{"name":"baobao","age":5}]}')
*!*	?"oJson.name",				oJson("name")
*!*	?"oJson.age",				oJson.Item("age")
*!*	?"oJson.childs",			oJson("childs").Count
*!*	?"oJson.childs[1].Name",	oJson("childs").item(1).item("name")
*!*	?"oJson.childs[1].age",		oJson("childs").item(1).item("age")
*!*	?"oJson.childs[2].Name",	oJson("childs").item(2).item("name")
*!*	?"oJson.childs[2].age",		oJson("childs").item(2).item("age")

Procedure foxJson_Parse(cJson)
	If Vartype(cJson)<>"C"
		Error(11)
		Return
	EndIf 
	
	Local cObj,vRetValue
	
	cObj=json_Parse(cJson)
	If not InList(json_Type(cObj),4,5)  && basic value
		vRetValue=json_value(cObj)
		
		json_Delete(vRetValue)
		Return vRetValue
	EndIf 
	
	*object or array
	vRetValue=NewObject("collection")
	
	foxJson_Parse_Enum(vRetValue,cObj)
	json_Delete(cObj)
	
	Return vRetValue
EndProc 
Procedure foxJson_Parse_Enum(oRet,cObj)
	Local x,nCount,nThisType
	Local oTmpObj
	nThisType=json_Type(cObj)
	nCount=json_Childs(cObj)
 
	For x=1 to nCount
		If InList(json_Type(cObj,x),4,5)
			*obj or array 
			oTmpObj=NewObject("collection")
			If nThisType=4
				oRet.Add(oTmpObj,json_Key(cObj,x))
			Else
				oRet.Add(oTmpObj)
			EndIf 
			
			*Recursion
			foxJson_Parse_Enum(oTmpObj,json_Value(cObj,x))
			Loop 
		EndIf 
		
		If nThisType=4
			oRet.Add(json_Value(cObj,x),json_Key(cObj,x))
		Else
			oRet.Add(json_Value(cObj,x))
		EndIf 
	EndFor 
EndProc 