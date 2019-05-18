*
DEFINE CLASS dila_money as Session

  PROCEDURE topup && 充值-------------------------
    userid1 = httpqueryparams("userid")
    czje1 = httpqueryparams("deposit") && 充值卡金额
    *写入充值记录表moneys
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [moneys] (userid,money,createtime,moneytype) VALUES (<<userid1>>,<<czje1>>,getdate(),1)
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
	*修改个人余额表  user
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      UPDATE [user] SET balance = balance+<<czje1>> WHERE userid = <<userid1>>
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE consumption && 消费记录-------------------------
    userid1 = httpqueryparams("userid")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT paytype,createtime,moneytype,money FROM [moneys] WHERE userid='<<userid1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("tmp")
  ENDPROC 

ENDDEFINE