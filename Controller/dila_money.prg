*
DEFINE CLASS dila_money as Session

  PROCEDURE topup && 充值-------------------------
    yh1 = httpqueryparams("phone")
    czje1 = httpqueryparams("deposit") && 充值卡金额
    *cs1 = httpqueryparams("times")
    IF VAL(czje1) = 299
      cs1 = 10
    ENDIF 
    IF VAL(czje1) = 1280
      cs1 = 50
    ENDIF 
    IF VAL(czje1) = 5380
      cs1 = 999
    ENDIF 
    *写入充值记录表moneys
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [moneys] (loginName,money,createtime,type,times) VALUES (<<yh1>>,<<czje1>>,getdate(),1,<<cs1>>)
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
	*修改个人余额表  user
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      UPDATE [user] SET balance = balance+<<czje1>>,times=times+<<cs1>> WHERE loginName = '<<yh1>>'
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE consumption && 消费记录-------------------------
    yh1 = httpqueryparams("phone")

    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT createtime,[moneys].money,[moneys].times,machinename FROM [moneys] left outer join machine ON [moneys].code = [machine].code where loginname='<<yh1>>'
    ENDTEXT	

 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("tmp")
  ENDPROC 

ENDDEFINE