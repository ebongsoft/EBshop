* 采购单 -------------------------------------------------

DEFINE CLASS dila_goods As Session

	PROCEDURE Mallhome && 商城首页
*!*		  cgdid1=httpqueryparams("cgdid") && ,this.iconnid
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    SELECT goodsname,goodsimg,marketprice from goods where issale=1 && marketprice 市场价，issale 是否上架
	  ENDTEXT
 	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	  IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
      RETURN cursortojson("tmp")
    ENDPROC 

ENDDEFINE 