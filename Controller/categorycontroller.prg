* 产品分类接口控制器
* 处理产品分类API
* Class CategoryController

define class CategoryController as Session

 
  *
  * 产品分类
  *
  procedure index

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



enddefine