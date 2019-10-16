* �û���ַ�ӿڿ�����
* �����û���ַ�������API
* Class AddressController

define class AddressController as Session


  *
  * ��ȡ�û���ַ���ݽӿ�
  *
  procedure index
    user_id1=val(HttpQueryParams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"�����쳣."}'
    endif    

    * ���е�ַ
    text to lcSQLCmd noshow textmerge
	   select * from [address] where uid=<<user_id1>> order by is_default desc,id desc
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"adds_list")<0
      return '{"status":0,"err":"�����쳣."}'
    endif 

    return DbfToJson("adds_list")
  endproc

  
  *
  * ��Ա��ӵ�ַ�ӿ�
  *
  procedure add_adds
    user_id1=val(HttpQueryParams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"�����쳣��"}'
    endif    

    * ����ajax������������
    name1=alltrim(HttpQueryParams("receiver"))
    tel1=alltrim(HttpQueryParams("tel"))
    sheng1=val(HttpQueryParams("sheng"))
    city1=val(HttpQueryParams("city"))
    quyu1=val(HttpQueryParams("quyu"))
    address1=ALLTRIM(HttpQueryParams("adds"))
    code1=ALLTRIM(HttpQueryParams("code"))
    uid1=val(HttpQueryParams("user_id"))
    if empty(name1) or empty(tel1) or empty(address1)
      return '{"status":0,"err":"����������Ϣ�����ύ."}'
    endif 
    if empty(sheng1) or empty(city1) or empty(quyu1)
      return '{"status":0,"err":"��ѡ��ʡ����."}'
    endif
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
    *** ��ѯ�ĵ�ַ�����Ƿ񱣴��
	  ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [address] WHERE address='{1}'",address1))
	  IF ss1>0
	    return '{"status":0,"err":"�õ�ַ�Ѿ������"}'
	  ENDIF 
	  province = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",sheng1))
	  city_name = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",city1))
    quyu_name = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",quyu1))
    address_xq = alltrim(province)+alltrrim(city_name)+alltrim(quyu_name)+alltrim(address1)
	  *** ��������
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    INSERT INTO [address] (name,tel,sheng,city,quyu,address,address_xq,code,uid) VALUES
      (name1,tel1,sheng1,city1,quyu1,address1,address_xq,code1,uid1)
  	ENDTEXT
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	    return '{"status":0,"err":"����ʧ��."}'
	  ENDIF   
    TEXT TO add_arr1 NOSHOW TEXTMERGE 
      "addrr_id":0,"rec":<<name1>>,"tel":<<tel1>>,"addr_xq":<<address_xq>>
    ENDTEXT
    return '{"status":1,"add_arrr":<<add_arr1>>}'
  endproc


  *
  * ��Ա��ȡ������ַ�ӿ�
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
  * ��Աɾ����ַ�ӿ�
  *
  procedure del_adds
    user_id1=int(HttpQueryParams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"�����쳣."}'
    endif
    id_arr1=HttpQueryParams("id_arr")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      delete from [address] where uid=<<user_id1>> and id=<<id_arr1>>
  	ENDTEXT
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	    return '{"status":0,"err":"����ʧ��."}'
	  ENDIF 
    return '{"status":1}'    
  endproc


  *
  * ��ȡʡ�����ݽӿ�
  *
  procedure get_province
    * ����ʡ��
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
  * ��ȡ�������ݽӿ�
  *
  procedure get_city
    sheng1=int(HttpQueryParams("sheng"))
    if empty(sheng1)
      return '{"status":0,"err":"��ѡ��ʡ��."}'
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
  * ��ȡ�������ݽӿ�
  *
  procedure get_area
    city1=int(HttpQueryParams("city"))
    if empty(city1)
      return '{"status":0,"err":"��ѡ�����."}'
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
  * ��ȡ������Žӿ�
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
  * ����Ĭ�ϵ�ַ
  *
  procedure set_default
    uid1=int(HttpQueryParams("uid"))
    if empty(uid1)
      return '{"status":0,"err":"��¼״̬�쳣."}'
    endif
    addr_id1=int(HttpQueryParams("addr_id"))
    if empty(addr_id1)
      return '{"status":0,"err":"��ַ��Ϣ����."}'
    endif    
    * �޸�Ĭ��״̬ 
    text to lcSQLCmd noshow textmerge
	    update from [address] set is_default=0 where uid=<<uid1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"code")<0
      return '{"status":0,"err":"����ʧ��."}'
    endif 
    * 
    text to lcSQLCmd1 noshow textmerge
	    update from [address] set is_default=1 where uid=<<uid1>> and id=<<addr_id1>>
	  endtext
 	  oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd1,"code")<0
      return '{"status":0,"err":"����ʧ��."}'
    endif    
    return '{"status":1}'

  endproc


enddefine