* user��
DEFINE CLASS dila_login as Session

  PROCEDURE login && ��¼-------------------------
    PRIVATE yh1,mm1
    *** ��ȡ����
    yh1=httpqueryparams("tel")
    mm1=md5(httpqueryparams("password"))
    *** ��ѯע����Ƿ����
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}' and loginPwd='{2}'",yh1,mm1))
    IF ss1>0
      RETURN '{"errno":0,"errmsg":"ok"}'
    ELSE 
      ERROR "���������˻�������" && '{"errno":1,"errmsg":"���������˻�������"}'
	ENDIF	
  ENDPROC 

  PROCEDURE register && ע��------------------------
    LOCAL yh1,mm1,yqr1
    *** ��ȡ����
    yh1=httpqueryparams("tel") 
    mm1=md5(httpqueryparams("password"))
    *** ��ѯע����Ƿ񱣴��
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}'",yh1))
	IF ss1>0
	  ERROR "�˻��Ѿ���ע��"
	ENDIF 
	*** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [user] (loginName,loginPwd,times,createtime,usercard) VALUES ('<<yh1>>','<<mm1>>',1,getdate(),"���鿨")
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	
	*** ����4λ����֤��
	bit4Rand1 = INT(RAND()*9000)+1000 && 4λ�����
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  UPDATE [user] SET bit4Rand=<<bit4Rand1>> where loginName='<<yh1>>'
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF 	  	
	
	DO WHILE .T.
	  *** ����һ�����6λ����������Ƿ��ظ������ظ�����������
	  sjs1=INT(RAND()*900000)+100000 && 6λ�����
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	  sjsss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE inviterid='{1}'",sjs1))
	  
	  IF sjsss1=0 && ���ݲ����ڣ�����ѭ����д��user���
	    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
		  UPDATE [user] SET inviterid=<<sjs1>> where loginName='<<yh1>>'
		ENDTEXT
		oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
		IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
		  ERROR oDBSQLHelper.errmsg
		ENDIF 	  
		EXIT 
	  ENDIF 
	ENDDO 
	
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE getcode && ��ȡ��֤��--------------------
    yh1=httpqueryparams("tel")
    *** ��ѯ�û�4λ����֤��
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss2 = oDBSQLhelper.GetSingle(stringformat("SELECT bit4Rand FROM [user] WHERE loginName='{1}'",yh1))
	IF ss2<=0
	  ERROR "��֤���ȡ��������ϵ�ͷ�"
	ENDIF 
	
	oXML = Createobject("Microsoft.XMLHTTP")
	*** ���ñ�����
	key1 = "5ee2e6487b823965556e"   && ��Կ 
	uid1 = "ebong1"               && ��½�˺�
	smsMob1  = yh1 && ALLTRIM(thisform.text1.value) && ������Ϣ�ĺ���    ���磺"15986989933"
	smsText1 = "�𾴵Ŀͻ���������֤���ǣ�"+ALLTRIM(STR(ss2))
	*** ������䡣����API�ӿڶ�Ӧ��
	lcUrl = "http://gbk.api.smschinese.cn/?"+"Uid="+uid1+"&"+"key="+key1+"&"+"smsMob="+smsMob1+"&"+"smsText="+smsText1
	oXML.Open("POST", lcUrl, .F.)&&  �������
	PostData  = " " + Chr(13) + Chr(10)
	oXML.setRequestHeader("Content-Length", Len(PostData))
	oXML.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	oXML.setRequestHeader("Content-type", "text/xml;charset=gb2312")
	oXML.Send(PostData)
	Do While oXML.ReadyState <> 4
	    =Inkey(1)
	ENDDO
	Release oXML
	oXML = Null
	
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE changepassword && �޸�����------------------------
    *** ��ȡ����
    yh1=httpqueryparams("tel") 
    yzm1 = VAL(httpqueryparams("code")) && ��֤��
    xmm1=md5(httpqueryparams("NewPassword"))
    zcsr1=md5(httpqueryparams("ConfirmPassword"))
    *** ��������Ƿ���ͬ
    IF ALLTRIM(xmm1)<>ALLTRIM(zcsr1)
      ERROR "��������벻һ��"
    ENDIF 
    *** ��ѯע����Ƿ񱣴��
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}'",yh1))
	IF ss1<=0
	  ERROR "���Ҳ������û�"
	ENDIF 
	**************
	**�Ա���֤��
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss2 = oDBSQLhelper.GetSingle(stringformat("SELECT bit4Rand FROM [user] WHERE loginName='{1}'",yh1))
    IF ALLTRIM(STR(ss2)) <> ALLTRIM(STR(yzm1))
      ERROR "��֤����������»�ȡ����ϵ�ͷ�"
    ENDIF 
	**************
	*** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  UPDATE [user] SET loginPwd = '<<xmm1>>' WHERE loginName='<<yh1>>'
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

ENDDEFINE 