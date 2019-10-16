* 产品分类接口控制器
* 处理产品分类API
* Class CategoryController

define class CategoryController as Session

 
  *
  * 产品分类
  *
  procedure index
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
    list1 = oDBSQLhelper.GetSingle("select id,tid,name,concent,bz_1,bz_2 from [category] where tid=1")
    return DbfToJson("adds_list")
  endproc


  *
  * 获取产品分类信息
  *
  procedure getcat
    catid1=val(HttpQueryParams("cat_id"))
    if empty(catid1)
      return '{"status":0,"err":"网络异常。"}'
    endif  

    text to lcSQLCmd noshow textmerge
	    select id,name,bz_1 from [category] where tid=<<catid1>>
	endtext
    oDBSQLhelper=newobject("MSSQLhelper","MSSQLhelper.prg")
    if oDBSQLhelper.SQLQuery(lcSQLCmd,"catList")<0
      return '{"status":0}'
    endif 
    return DbfToJson("catList")
  endproc


enddefine