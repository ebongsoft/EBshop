* 蒂拉订单-----------------

DEFINE CLASS dila_order as Session 

  PROCEDURE order && 显示订单-------------------------
    yh1 = httpqueryparams("phone")

	oDBSQLhelper=Newobject("MSSQLhelper","MSSQLhelper.prg")
	oQiyuJson=Newobject("QiyuJson","QiyuJson.prg")

	TEXT TO lcSQLCmd NOSHOW TEXTMERGE PRETEXT 1+2
	  SELECT username,userphone,useraddress,addressid FROM [address] WHERE isdefault=1 AND loginName='<<yh1>>'
	ENDTEXT
	nRow=oDBSQLhelper.SQLQuery(lcSQLCmd,"buy_main")
	If nRow<0
		Error oDBSQLhelper.errmsg
	Endif
	oQiyuJson.AppendCursorToObj("buy_main","data")

	TEXT TO lcSQLCmd NOSHOW TEXTMERGE PRETEXT 1+2
	  select loginName,goodsid,num from carts where num>0 and loginName='<<yh1>>'
	ENDTEXT
	nRow=oDBSQLhelper.SQLQuery(lcSQLCmd,"buy_detail")
	*nRow=oDBSQLhelper.SQLQuery(lcSQLCmd,"buy_detail2")
	If nRow<0
		Error oDBSQLhelper.errmsg
	Endif
	oQiyuJson.appendcursor("buy_detail",nRow,"test")  &&单表
	*oQiyuJson.appendcursor("buy_detail2",nRow,"test1")  &&单表
	_cliptext=oQiyuJson.tojson()
    RETURN _cliptext
  ENDPROC 

  PROCEDURE addorder && 下单-------------------------
    yh1 = httpqueryparams("phone")
    cp1 = httpqueryparams("goodsid")
    cpmc1 = httpqueryparams("goodsname")
    sl1 = httpqueryparams("num")
    dz1 = httpqueryparams("addressid")
    psfs1 = httpqueryparams("paytype")
    IF ALLTRIM(psfs1)='到付'
      psfs1 = 1
    ELSE 
      psfs1 = 0
    ENDIF 
    yf1 = httpqueryparams("freight")
    ly1 = httpqueryparams("remark")
*!*	    fjid1 = httpqueryparams("parentid")
    *查询我的收货地址       
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
		INSERT INTO [orders] (loginName,goodsid,num,goodsname,addressid,paytype,freight,remark) VALUES ('<<yh1>>',<<cp1>>,<<sl1>>,'<<cpmc1>>',<<dz1>>,<<psfs1>>,<<yf1>>,'<<ly1>>')
    ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE assets && 显示我的资产 -------------------
    yh1 = httpqueryparams("phone")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT cash,balance FROM [user] where loginName='<<yh1>>'
    ENDTEXT	
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("tmp")
  ENDPROC 

  PROCEDURE stock && 显示我的库存 -------------------
    yh1 = httpqueryparams("phone")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT goodsname,stock FROM [userstock] where loginName='<<yh1>>'
    ENDTEXT	
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("tmp")
  ENDPROC 
  
  PROCEDURE low_order && 显示我的下级库存 -------------------
    yh1 = httpqueryparams("phone")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT createtime,goodsname,cash,num FROM [orders] where loginName='<<yh1>>'
    ENDTEXT	
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("tmp")
  ENDPROC 
  
ENDDEFINE 