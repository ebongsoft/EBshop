* 用户地址接口控制器
* 处理用户地址数据相关API
* Class AddressController

define class AddressController as Session

  * 获取用户地址数据接口
  procedure index
    user_id1=httpqueryparams("user_id")
    if empty(user_id1)
      return '{"status":0,"err":"网络异常。"}'
    endif    
    * 所有地址
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	   select * from lr_address where uid=<<user_id1>> order by is_default desc,id desc
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"adds_list")<0
      ERROR '{"status":0,"err":"网络异常。"}'
    ENDIF 
    * RETURN cursortojson("adds_list")
    RETURN DbfToJson("adds_list")
  endproc


enddefine