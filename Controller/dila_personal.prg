*
DEFINE CLASS dila_personal as Session

  PROCEDURE personal && 显示个人中心内容-------------------------
    userid1 = httpqueryparams("userid")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT nickname,balance,lvevl FROM [user] WHERE userid='<<userid1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"personal")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("personal")
  ENDPROC 


ENDDEFINE