* �û���ַ�ӿڿ�����
* �����û���ַ�������API
* Class AddressController

define class AddressController as Session

  * ��ȡ�û���ַ���ݽӿ�
  procedure index
    user_id1=httpqueryparams("user_id")
    if empty(user_id1)
      return '{"status":0,"err":"�����쳣��"}'
    endif    
    * ���е�ַ
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	   select * from lr_address where uid=<<user_id1>> order by is_default desc,id desc
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"adds_list")<0
      ERROR '{"status":0,"err":"�����쳣��"}'
    ENDIF 
    * RETURN cursortojson("adds_list")
    RETURN DbfToJson("adds_list")
  endproc


enddefine