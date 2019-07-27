* �������ﳵ-----------------

DEFINE CLASS dila_carts as Session 

  PROCEDURE cart && ��ʾ���ﳵ-------------------------
    yh1 = httpqueryparams("phone")
    *��ѯ�ҵ��ջ���ַ
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT [goods].goodsid,[goods].goodsname,[goods].brands,[goods].goodsstock,[goods].goodsunit,[goods].marketprice as money FROM [carts] left outer join goods ON [carts].goodsid = [goods].goodsid where loginname='<<yh1>>'  
    ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    RETURN cursortojson("tmp")
  ENDPROC 

  PROCEDURE addcart && ��ӹ��ﳵ------------------------
    *** ��ȡ����
    yh1=httpqueryparams("phone") 
    cpid1=VAL(httpqueryparams("goodsid"))
    jg1 = VAL(httpqueryparams("marketprice"))
    *** ��ѯ	
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
    ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [carts] WHERE loginName='{1}' and goodsid={2}",yh1,cpid1))
	IF ss1>0
	  *** �޸�����
      TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    UPDATE [carts] SET num=0,marketprice=<<jg1>> WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
	  ENDTEXT
	ELSE 
	  *** ��������
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

  PROCEDURE cartplus && ���ﳵ�Ӻ�------------------------
    *** ��ȡ����
    yh1=httpqueryparams("tel") 
    cpid1=VAL(httpqueryparams("goodsid"))
    num1=VAL(httpqueryparams("num"))
    *** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      UPDATE [carts] SET num = num+<<num1>> WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE cartminus && ���ﳵ����------------------------
    *** ��ȡ����
    yh1=httpqueryparams("tel") 
    cpid1=VAL(httpqueryparams("goodsid"))
    num1=VAL(httpqueryparams("num"))
    *** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      UPDATE [carts] SET num = num-<<num1>> WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE delcart && ɾ�����ﳵ��Ʒ------------------------
    *** ��ȡ����
    yh1=httpqueryparams("tel") 
    cpid1=VAL(httpqueryparams("goodsid"))
    *** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      DELETE  FROM [carts] WHERE loginName='<<yh1>>' AND goodsid=<<cpid1>>
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 
  
  PROCEDURE order_cart && ���ﳵ�µ�-------------------------
    yh1 = httpqueryparams("phone")
    cpid1=VAL(httpqueryparams("goodsid"))
    num1=VAL(httpqueryparams("num"))
    ze1 = VAL(httpqueryparams("totalmoney"))
    *** ��������
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