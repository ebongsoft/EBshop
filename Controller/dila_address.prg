* 蒂拉商城用户地址管理-----------------

DEFINE CLASS dila_address as Session 

  PROCEDURE map && 显示收货人地址-------------------------
    yh1 = httpqueryparams("tel")
    *查询我的收货地址
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT username,userphone,area,useraddress,addressid from address where loginName='<<yh1>>' 
    ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    RETURN cursortojson("tmp")
  ENDPROC 

  PROCEDURE newaddress && 新增收货人地址-------------------------
    yh1 = httpqueryparams("tel")
    yhmc1 = httpqueryparams("username")
    qy1 = httpqueryparams("area")
    xxdz1 = httpqueryparams("address")
    lxdh1 = httpqueryparams("userphone")
    *查询是否有默认地址
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [address] WHERE isdefault=1 and loginName='{1}'",yh1))
	IF ss1<=0
	  mrdz1 = 1 && 没有默认地址，当前为默认地址
	ELSE 
	  mrdz1 = 0 && 有默认地址，等用于自行去修改
	ENDIF 
    *新增地址信息
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [address] (loginName,username,area,useraddress,userphone,createtime,isdefault) VALUES (<<yh1>>,'<<yhmc1>>','<<qy1>>','<<xxdz1>>','<<lxdh1>>',getdate(),<<mrdz1>>)
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE editaddress && 修改收货人地址-------------------------
    id1 = httpqueryparams("addressid")
    yh1 = httpqueryparams("tel")
    yhmc1 = httpqueryparams("username")
    qy1 = httpqueryparams("area")
    xxdz1 = httpqueryparams("address")
    lxdh1 = httpqueryparams("userphone")
    mrdz1 = httpqueryparams("isdefault")
    IF VAL(mrdz1)=1 && 如果用户修改当前设置为默认
	  *将全部默认值设置为0
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    UPDATE [address] SET isdefault=0 WHERE loginName='<<yh1>>'
	  ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	    ERROR oDBSQLHelper.errmsg
	  ENDIF	
    ENDIF 
    *修改地址信息
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	   UPDATE [address] SET username='<<yhmc1>>',area='<<qy1>>',useraddress='<<xxdz1>>',userphone='<<lxdh1>>',isdefault=<<mrdz1>> WHERE addressid = <<id1>> 
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
    IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}' 
  ENDPROC 
  
  
  PROCEDURE deladdress && 删除收货人地址-------------------------
    id1 = httpqueryparams("addressid")
    *删除地址信息
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  DELETE FROM [address] WHERE addressid = <<id1>>
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

ENDDEFINE 