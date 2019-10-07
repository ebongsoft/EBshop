* 用户地址接口控制器
* 处理用户地址数据相关API
* Class AddressController

define class AddressController as Session

  *
  * 获取用户地址数据接口
  *
  procedure index
    user_id1=val(httpqueryparams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"网络异常."}'
    endif    
    * 所有地址
    text to lcSQLCmd noshow textmerge
	   select * from lr_address where uid=<<user_id1>> order by is_default desc,id desc
	endtext
 	oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"adds_list")<0
      return '{"status":0,"err":"网络异常."}'
    endif 
    return DbfToJson("adds_list")
  endproc

  
  *
  * 会员添加地址接口
  *
  procedure add_adds
    user_id1=val(httpqueryparams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"网络异常。"}'
    endif    
    * 接收ajax传过来的数据
    name1=alltrim(httpqueryparams("receiver"))
    tel1=alltrim(httpqueryparams("tel"))
    sheng1=val(httpqueryparams("sheng"))
    city1=val(httpqueryparams("city"))
    quyu1=val(httpqueryparams("quyu"))
    address1=ALLTRIM(httpqueryparams("adds"))
    code1=ALLTRIM(httpqueryparams("code"))
    uid1=val(httpqueryparams("user_id"))
  
    if empty(name1) or empty(tel1) or empty(address1)
      return '{"status":0,"err":"请先完善信息后再提交."}'
    endif 
    if empty(sheng1) or empty(city1) or empty(quyu)
      return '{"status":0,"err":"请选择省市区."}'
    endif
    
    * 判断地址是否已添加
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [lr_address] WHERE adds='{1}' ",address1))
    IF ss1>0
      RETURN  '{"status":0,"err":"该地址已经添加了."}'
	ENDIF	

  endproc


enddefine