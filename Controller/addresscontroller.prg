* �û���ַ�ӿڿ�����
* �����û���ַ�������API
* Class AddressController

define class AddressController as Session

  *
  * ��ȡ�û���ַ���ݽӿ�
  *
  procedure index
    user_id1=val(httpqueryparams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"�����쳣."}'
    endif    
    * ���е�ַ
    text to lcSQLCmd noshow textmerge
	   select * from lr_address where uid=<<user_id1>> order by is_default desc,id desc
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
    user_id1=val(httpqueryparams("user_id"))
    if empty(user_id1)
      return '{"status":0,"err":"�����쳣��"}'
    endif    
    * ����ajax������������
    name1=alltrim(httpqueryparams("receiver"))
    tel1=alltrim(httpqueryparams("tel"))
    sheng1=val(httpqueryparams("sheng"))
    city1=val(httpqueryparams("city"))
    quyu1=val(httpqueryparams("quyu"))
    address1=ALLTRIM(httpqueryparams("adds"))
    code1=ALLTRIM(httpqueryparams("code"))
    uid1=val(httpqueryparams("user_id"))
  
    if empty(name1) or empty(tel1) or empty(address1)
      return '{"status":0,"err":"����������Ϣ�����ύ."}'
    endif 
    if empty(sheng1) or empty(city1) or empty(quyu)
      return '{"status":0,"err":"��ѡ��ʡ����."}'
    endif
    
    * �жϵ�ַ�Ƿ������
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [lr_address] WHERE adds='{1}' ",address1))
    IF ss1>0
      RETURN  '{"status":0,"err":"�õ�ַ�Ѿ������."}'
	ENDIF	

  endproc


enddefine