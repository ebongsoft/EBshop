* class foxJson 
* 对foxjson.fll的封装类，继承自vfp的Collection类，可以像集合一样访问json数据
* by 木瓜,2013
Set Library To foxjson



Define Class foxJson as Collection 
	*Json值
	Value=""
	*值的键
	Key=""
	*值的类型
	Type=0
	*子对像个数
	Count=0
	
	*======================================================================
	*构造函数 
	Procedure Init(value)
		If Pcount()=0
			this._Object=json_Create()
			Return 
		EndIf 
		
		If Vartype(value) $"INLCXD"  &&数值，小数，逻辑，字符，null,array
			this._Object=json_Create(value)
			Return 
		EndIf 
		
		If Vartype(value)="O" and value.Class==this.Class 
			this._Object=json_Parse( val.ToString())
			Return 
		EndIf 
		
		*参数错误
		Error(11)
	EndProc 
	*
	Procedure Destroy()
 		json_Delete(this._Object)
	EndProc 
	*======================================================================
	*索引器
	Procedure Item(name) as Object 
		NoDefault 
		If not Vartype(m.name) $ "CIN"
			Error(2061)
		EndIf 
		
		If this.isArray() and Vartype(m.name)="C"
			Error(2061)
		EndIf 

		Private  oJson 		
		
		If InList(json_Type(this._Object,m.name),4,5)
			*数组和对像
			oJson =NewObject(this.Class)
			json_Delete(oJson._Object)
			
			oJson._Object=json_Value(this._Object,m.name)
			json_AddRef(oJson._Object)
			Return oJson
		EndIf 
		
		*值类型
		oJson=NewObject("empty")
		AddProperty(oJson,"Value",json_Value(this._Object,m.name))
		AddProperty(oJson,"Type",json_Type(this._Object,m.name))
		If this.isObject()
			If Vartype(m.name) $ "IN" 
				AddProperty(oJson,"Key",json_Key(this._Object,m.name))
			Else
				AddProperty(oJson,"Key",m.name)
			EndIf 
		EndIf 
		Return oJson
	EndProc 
	*======================================================================
	*解析器
	Procedure Parse(cJson)
		json_Delete(this._Object)
		this._Object=json_Parse(cJson)
	EndProc 
	*======================================================================
	*ToString
	Procedure ToString()
		Return json_toString(this._Object)
	EndProc 
	*======================================================================
	*追加
	Procedure Append(cKey,vValue)  && cKey|vValue,vValue
		
		*数组
		If Pcount()=1 and this.isArray()
		
			If Vartype(cKey) $"INLCXDY"  &&数值，小数，逻辑，字符，null,array
				json_Append(this._Object,json_Create(cKey))
				Return 
			EndIf 
			
			If Vartype(cKey)="O" and cKey.Class==this.Class 
				json_Append(this._Object,json_Parse( cKey.ToString()))
				Return 
			EndIf 
		
			Error(11)
			Return 
		EndIf 
		
		*对像
		If Pcount()=2 and this.isObject() and Vartype(cKey)="C"
		    IF Vartype(vValue)=="T"
		    	json_Append(this._Object,json_Create(TTOc(vValue,3)),cKey)
				Return
		    ENDIF 
		    
	    
			If Vartype(vValue) $"INLCXD"  &&数值，小数，逻辑，字符，null,array,货币
				json_Append(this._Object,json_Create(vValue),cKey)
				Return 
			EndIf 
			
			If Vartype(vValue) $"Y"  &&货币
			    LOCAL tmp_x1
			    tmp_x1=cast(vValue as n)
				json_Append(this._Object,json_Create(tmp_x1),cKey)
				Return 
			EndIf 
						
			If Vartype(vValue)="O" and vValue.Class==this.Class 
				json_Append(this._Object,json_Parse( vValue.ToString()),cKey)
				Return 
			EndIf 
		
			Error(11)
			Return 
		EndIf 
		
		Error(11)  
	EndProc 
	*======================================================================
	*移除
	Procedure Remove(cKey)  &&cKey|vIdx
		NoDefault 
		If this.IsObject() and Vartype(cKey)$"CINY"
			json_Remove(this._Object,cKey)
			Return 
		EndIf 
		
		If this.IsArray() and Vartype(cKey) $"INY"
			json_Remove(this._Object,cKey)
			Return 
		EndIf 
		
		Error(11)  
	EndProc 
	*======================================================================
	Procedure Value_Access
		If this.isObject() or this.isArray()
			Error(2061)
		EndIf 
		Return json_Value(this._Object)
	EndProc 
	*======================================================================
	Procedure Key_Access
		Return json_Key(this._Object)
	EndProc 
	*======================================================================
	Procedure Count_Access
		If this.isObject() or this.isArray()
			Return json_Childs(this._Object)
		EndIf 
		Error(2061)
	EndProc 
	*======================================================================
	Procedure Type_Access
		Return json_Type(this._Object)
	EndProc 
	*======================================================================
	Procedure isNull()
		Return json_Type(this._Object)==0
	EndProc 
	
	Procedure isBool()
		Return json_Type(this._Object)==1
	EndProc 
	
	Procedure isDouble()
		Return json_Type(this._Object)==2
	EndProc 
	
	Procedure isInt()
		Return json_Type(this._Object)==3
	EndProc 
	
	Procedure isObject()
		Return json_Type(this._Object)==4
	EndProc 
	
	Procedure isArray()
		Return json_Type(this._Object)==5
	EndProc 
	
	Procedure isString()
		Return json_Type(this._Object)==6
	EndProc 
	*======================================================================
	*json object 
	*Protected _Object  	
	_Object="" 
EndDefine 