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
    yqr1=httpqueryparams("inviter")
    *** ��ѯע����Ƿ񱣴��
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}'",yh1))
	IF ss1>0
	  ERROR "�˻��Ѿ���ע��"
	ENDIF 
	*** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [user] (loginName,loginPwd,inviter) VALUES ('<<yh1>>','<<mm1>>','<<yqr1>>')
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE changepassword && �޸�����------------------------
    *** ��ȡ����
    yh1=httpqueryparams("tel") 
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