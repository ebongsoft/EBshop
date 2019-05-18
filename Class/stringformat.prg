Function StringFormat
Parameters cText,Parameter1,Parameter2,Parameter3,Parameter4,Parameter5,Parameter6,Parameter7,Parameter8,Parameter9,Parameter10
Local _tokens As Collection,cEndText As String,nCount As Integer,cName As String,oTokenParser As Object
Local oPara As Collection
cEndText=""
If Vartype(cText) <>"C"
	ERROR "�����ַ�����ʽ����"
ENDIF

*--��������
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
*--�ж�{}�Ƿ����Ҫ��
		cTmp=Substr(token,2,Len(token)-2)
		IF VAL(cTmp)=0
		 ERROR "����{}����Ϊ��"
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
*--��״̬�ı��ʱ��Ӧ������֮ǰ�Ѵ���ļĴ����е�����
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
*--��Ϊֻ������״̬�����
	This._currentMode= This._lastMode
	Endproc
	Procedure ParseTemplate
	Lparameters template
	For i=1 To Len(template)
		c=Substr(template,i,1)
		Do Case
		Case c=LABEL_OPEN_CHAR
			This.EnterMode(1)
			&&����ǰ�ַ�ѹ��Ĵ�����ͬ���Ĵ�����������֧��������
			&&���������д�����ֵ�ʱ��
			&&�ڲ�ͬ��״̬�¿��ܳ��ֲ�ͬ�Ĵ������
			This._temp = This._temp +c
		Case c=LABEL_CLOSE_CHAR
			&& ����ǰ�ַ�ѹ��Ĵ���
			This._temp =This._temp + c
			&&��Ϊ����ֻ������״̬����������൱�ڣ�_EnterMode(ParserMode.LeaveLabel)
			&&����Ϊ������һ�£��һ��Ƕ���������������ʵ��
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