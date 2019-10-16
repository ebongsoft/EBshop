* 用户地址接口控制器
* 处理用户地址数据相关API
* Class AddressController

define class AddressController as Session


  *
  * 获取用户地址数据接口
  *
  procedure index
    user_id1=val(HttpQueryParams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"网络异常."}'
    endif    

    * 所有地址
    text to lcSQLCmd noshow textmerge
	   select * from [address] where uid=<<user_id1>> order by is_default desc,id desc
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
    user_id1=val(HttpQueryParams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"网络异常。"}'
    endif    

    * 接收ajax传过来的数据
    name1=alltrim(HttpQueryParams("receiver"))
    tel1=alltrim(HttpQueryParams("tel"))
    sheng1=val(HttpQueryParams("sheng"))
    city1=val(HttpQueryParams("city"))
    quyu1=val(HttpQueryParams("quyu"))
    address1=ALLTRIM(HttpQueryParams("adds"))
    code1=ALLTRIM(HttpQueryParams("code"))
    uid1=val(HttpQueryParams("user_id"))
    if empty(name1) or empty(tel1) or empty(address1)
      return '{"status":0,"err":"请先完善信息后再提交."}'
    endif 
    if empty(sheng1) or empty(city1) or empty(quyu1)
      return '{"status":0,"err":"请选择省市区."}'
    endif
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
    *** 查询改地址内容是否保存过
	  ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [address] WHERE address='{1}'",address1))
	  IF ss1>0
	    return '{"status":0,"err":"该地址已经添加了"}'
	  ENDIF 
	  province = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",sheng1))
	  city_name = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",city1))
    quyu_name = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",quyu1))
    address_xq = alltrim(province)+alltrrim(city_name)+alltrim(quyu_name)+alltrim(address1)
	  *** 保存数据
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    INSERT INTO [address] (name,tel,sheng,city,quyu,address,address_xq,code,uid) VALUES
      (name1,tel1,sheng1,city1,quyu1,address1,address_xq,code1,uid1)
  	ENDTEXT
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	    return '{"status":0,"err":"操作失败."}'
	  ENDIF   
    TEXT TO add_arr1 NOSHOW TEXTMERGE 
      "addrr_id":0,"rec":<<name1>>,"tel":<<tel1>>,"addr_xq":<<address_xq>>
    ENDTEXT
    return '{"status":1,"add_arrr":<<add_arr1>>}'
  endproc


  *
  * 会员获取单个地址接口
  *
  procedure  details
    addr_id1=int(HttpQueryParams("addr_id"))
    if empty(addr_id1)
      return '{"status":0}'
    endif

    text to lcSQLCmd noshow textmerge
	   select id as addr_id,name,tel,address_xq as addr_xq from [address] where id=<<addr_id1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"arr")<0
      return '{"status":0}'
    endif 
    return DbfToJson("arr")    
  endproc


  *
  * 会员删除地址接口
  *
  procedure del_adds
    user_id1=int(HttpQueryParams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"网络异常."}'
    endif
    id_arr1=HttpQueryParams("id_arr")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      delete from [address] where uid=<<user_id1>> and id=<<id_arr1>>
  	ENDTEXT
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	    return '{"status":0,"err":"操作失败."}'
	  ENDIF 
    return '{"status":1}'    
  endproc


  *
  * 获取省份数据接口
  *
  procedure get_province
    * 所有省份
    china_city1=int(HttpQueryParams("china_city"))
    text to lcSQLCmd noshow textmerge
	    select id,name from [china_city] where tid=0
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"china_city")<0
      return '{"status":0}'
    endif 
    return DbfToJson("china_city")
  endproc 


  *
  * 获取城市数据接口
  *
  procedure get_city
    sheng1=int(HttpQueryParams("sheng"))
    if empty(sheng1)
      return '{"status":0,"err":"请选择省份."}'
    endif
    text to lcSQLCmd noshow textmerge
	    select id,name from [china_city] where tid=<<sheng1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"city_list")<0
      return '{"status":0}'
    endif 
    return DbfToJson("city_list")
  endproc 


  *
  * 获取区域数据接口
  *
  procedure get_area
    city1=int(HttpQueryParams("city"))
    if empty(city1)
      return '{"status":0,"err":"请选择城市."}'
    endif
    text to lcSQLCmd noshow textmerge
	    select id,name from [china_city] where tid=<<city1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"area_list")<0
      return '{"status":0}'
    endif 
    return DbfToJson("area_list")
  endproc 


  *
  * 获取邮政编号接口
  *
  procedure get_code
    quyu1=int(HttpQueryParams("quyu"))
    text to lcSQLCmd noshow textmerge
	    select code from [china_city] where tid=<<quyu1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"code")<0
      return '{"status":0}'
    endif 
    return DbfToJson("code")
  endproc


  *
  * 设置默认地址
  *
  procedure set_default
    uid1=int(HttpQueryParams("uid"))
    if empty(uid1)
      return '{"status":0,"err":"登录状态异常."}'
    endif
    addr_id1=int(HttpQueryParams("addr_id"))
    if empty(addr_id1)
      return '{"status":0,"err":"地址信息错误."}'
    endif    
    * 修改默认状态 
    text to lcSQLCmd noshow textmerge
	    update from [address] set is_default=0 where uid=<<uid1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"code")<0
      return '{"status":0,"err":"设置失败."}'
    endif 
    * 
    text to lcSQLCmd1 noshow textmerge
	    update from [address] set is_default=1 where uid=<<uid1>> and id=<<addr_id1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd1,"code")<0
      return '{"status":0,"err":"设置失败."}'
    endif    
    return '{"status":1}'

  endproc


enddefine