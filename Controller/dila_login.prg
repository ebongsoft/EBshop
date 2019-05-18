* user表
DEFINE CLASS dila_login as Session

  PROCEDURE login && 登录-------------------------
    PRIVATE yh1,mm1
    *** 获取变量
    yh1=httpqueryparams("tel")
    mm1=md5(httpqueryparams("password"))
    *** 查询注册号是否存在
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}' and loginPwd='{2}'",yh1,mm1))
    IF ss1>0
      RETURN '{"errno":0,"errmsg":"ok"}'
    ELSE 
      ERROR "密码错误或账户不存在" && '{"errno":1,"errmsg":"密码错误或账户不存在"}'
	ENDIF	
  ENDPROC 

  PROCEDURE register && 注册------------------------
    LOCAL yh1,mm1,yqr1
    *** 获取变量
    yh1=httpqueryparams("tel") 
    mm1=md5(httpqueryparams("password"))
    yqr1=httpqueryparams("inviter")
    *** 查询注册号是否保存过
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}'",yh1))
	IF ss1>0
	  ERROR "账户已经被注册"
	ENDIF 
	*** 保存数据
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [user] (loginName,loginPwd,inviter) VALUES ('<<yh1>>','<<mm1>>','<<yqr1>>')
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE changepassword && 修改密码------------------------
    *** 获取变量
    yh1=httpqueryparams("tel") 
    xmm1=md5(httpqueryparams("NewPassword"))
    zcsr1=md5(httpqueryparams("ConfirmPassword"))
    *** 检查密码是否相同
    IF ALLTRIM(xmm1)<>ALLTRIM(zcsr1)
      ERROR "输入的密码不一致"
    ENDIF 
    *** 查询注册号是否保存过
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE loginName='{1}'",yh1))
	IF ss1<=0
	  ERROR "查找不到该用户"
	ENDIF 
	*** 保存数据
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