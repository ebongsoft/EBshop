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
	  province = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",sheng1))
	  city_name = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",city1))
    quyu_name = oDBSQLhelper.GetSingle(stringformat("SELECT name FROM [china_city] WHERE id='{1}' ",quyu1))
    RETURN province+city_name+quyu_name


  endproc


enddefine