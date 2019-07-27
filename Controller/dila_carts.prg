* 蒂拉购物车-----------------

DEFINE CLASS dila_carts as Session 

  PROCEDURE cart && 显示购物车-------------------------
    yh1 = httpqueryparams("phone")
    *查询我的收货地址
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT [goods].goodsid,[goods].goodsname,[goods].brands,[goods].goodsstock,[goods].goodsunit,[goods].marketprice as money FROM [carts] left outer join goods ON [carts].goodsid = [goods].goodsid where loginname='<<yh1>>'  
    ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    RETURN cursortojson("tmp")
  ENDPROC 

  PROCEDURE addcart && 添加购物车------------------------
    *** 获取变量
    yh1=httpqueryparams("phone") 
    cpid1=VAL(httpqueryparams("goodsid"))
    jg1 = VAL(httpqueryparams("marketprice"))
    *** 查询	
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
    ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [carts] WHERE loginName='{1}' and goodsid={2}",yh1,cpid1))
	IF ss1>0
	  *** 修改数据
      TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    UPDATE [carts] SET num=0,marketprice=<<jg1>> WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
	  ENDTEXT
	ELSE 
	  *** 保存数据
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
		INSERT INTO [carts] (loginName,goodsid,num,marketprice) VALUES ('<<yh1>>',<<cpid1>>,0,<<jg1>>)
	  ENDTEXT	
	ENDIF 
	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE cartplus && 购物车加号------------------------
    *** 获取变量
    yh1=httpqueryparams("tel") 
    cpid1=VAL(httpqueryparams("goodsid"))
    num1=VAL(httpqueryparams("num"))
    *** 保存数据
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      UPDATE [carts] SET num = num+<<num1>> WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE cartminus && 购物车减号------------------------
    *** 获取变量
    yh1=httpqueryparams("tel") 
    cpid1=VAL(httpqueryparams("goodsid"))
    num1=VAL(httpqueryparams("num"))
    *** 保存数据
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      UPDATE [carts] SET num = num-<<num1>> WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE delcart && 删除购物车产品------------------------
    *** 获取变量
    yh1=httpqueryparams("tel") 
    cpid1=VAL(httpqueryparams("goodsid"))
    *** 保存数据
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      DELETE  FROM [carts] WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE order_cart && 购物车下单-------------------------
    yh1 = httpqueryparams("phone")
    cpid1=VAL(httpqueryparams("goodsid"))
    num1=VAL(httpqueryparams("num"))
    ze1 = VAL(httpqueryparams("totalmoney"))
    *** 保存数据
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      INSERT INTO [orders] (loginName,goodsid,num,totalmoney) VALUES ('<<yh1>>',<<cpid1>>,<<num1>>,<<ze1>>)
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

ENDDEFINE 