* ��Ʒ����ӿڿ�����
* �����Ʒ����API
* Class CategoryController

define class CategoryController as Session

 
  *
  * ��Ʒ����
  *
  procedure index

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



enddefine