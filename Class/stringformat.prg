Function StringFormat
Parameters cText,Parameter1,Parameter2,Parameter3,Parameter4,Parameter5,Parameter6,Parameter7,Parameter8,Parameter9,Parameter10
Local _tokens As Collection,cEndText As String,nCount As Integer,cName As String,oTokenParser As Object
Local oPara As Collection
cEndText=""
If Vartype(cText) <>"C"
	ERROR "传入字符串格式不对"
ENDIF

*--创建集合
oPara=Createobject("Collection")
For nCount=1 To 10
	cName="Parameter"+Alltrim(Str(nCount))
	oPara.Add(&cName)
Endfor
oTokenParser =Createobject("TokenParser")
oTokenParser.ParseTemplate(cText)
nCount=1
For Each token In oTokenParser._tokens
	If Like("{*}",token)
*--判断{}是否符合要求
		cTmp=Substr(token,2,Len(token)-2)
		IF VAL(cTmp)=0
		 ERROR "参数{}不能为零"
		ENDIF 
		If Isdigit(cTmp)  And Val(cTmp)<=10 
			cVal=oPara.Item(Val(cTmp))
			Do Case
			Case Vartype(cVal)=="C"
				cEndText = cEndText +cVal
			Case Vartype(cVal)=="L"
				cEndText = cEndText+Iif(cVal==.T.,".T.",".F.")
			Case Vartype(cVal )=="N"
				cEndText =cEndText +transform(cVal)
			Case Vartype(cVal)=="D"
				cEndText =cEndText +"{^" +Dtoc(cVal)+"}"
			Case Vartype(cVal)=="T"
				cEndText =cEndText +"{^" +Ttoc(cVal)+"}"
			Endcase
			nCount = nCount +1
		Endif
	Else
		cEndText = cEndText +token
	Endif
Endfor
Return cEndText
Endfunc


#Define LABEL_OPEN_CHAR = '{'
#Define LABEL_CLOSE_CHAR = '}'
Define Class TokenParser As Custom
	_tokens=.F.
	_temp=""
	_currentMode=.F.
	_lastMode=.F.
	Procedure Init
	Local tty As Collection
	tty=Createobject("collection")
	This._tokens=tty
	Endproc
	Procedure EnterMode
	Lparameters mode
*--当状态改变的时候应当保存之前已处理的寄存器中的内容
	If Len(This._temp) >0
		This._tokens.Add(This._temp)
		This._temp=""
	Endif
	This._lastMode=This._currentMode
	This._currentMode = mode
	Endproc
	Procedure LeaveMode
	If Len(This._temp)>0
		This._tokens.Add(This._temp)
		This._temp=""
	Endif
*--因为只有两个状态，因此
	This._currentMode= This._lastMode
	Endproc
	Procedure ParseTemplate
	Lparameters template
	For i=1 To Len(template)
		c=Substr(template,i,1)
		Do Case
		Case c=LABEL_OPEN_CHAR
			This.EnterMode(1)
			&&将当前字符压入寄存器，同样的代码在三个分支都出现了
			&&请留意这行代码出现的时机
			&&在不同的状态下可能出现不同的处理过程
			This._temp = This._temp +c
		Case c=LABEL_CLOSE_CHAR
			&& 将当前字符压入寄存器
			This._temp =This._temp + c
			&&因为本例只有两个状态，因此这里相当于：_EnterMode(ParserMode.LeaveLabel)
			&&但是为了区别一下，我还是定义了两个方法来实现
			This.LeaveMode()
		Otherwise
			This._temp =This._temp + c
		Endcase
	ENDFOR
	IF !EMPTY(This._temp)
		This._tokens.Add(This._temp)
		This._temp=""
	ENDIF 
	Endproc
Enddefine