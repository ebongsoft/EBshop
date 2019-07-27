*
DEFINE CLASS dila_personal as Session

  PROCEDURE personal && 显示个人中心内容-------------------------
    yh1 = httpqueryparams("phone")
    IF LEN(yh1)=0
      ERROR '没有获取到注册号'
    ENDIF 
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT loginName,times,rankname,usercard,inviterid,isnull(str(parentid),'null') as parentid from [user] left outer join rank ON [user].rankid = [rank].rankid  where loginname='<<yh1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"personal")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("personal")
  ENDPROC 

  PROCEDURE attorney  && 授权书-------------------------
    yh1 = httpqueryparams("phone")
    IF LEN(yh1)=0
      ERROR '没有获取到注册号'
    ENDIF 
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT realName,[rank].rankname,loginName,createtime from [user] left outer join rank ON [user].rankid = [rank].rankid  where loginname='<<yh1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"attorney")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("attorney")
  ENDPROC 

  PROCEDURE apply && 上传充值凭证 -------------------------
    *保存图片
    oFile=getupfile()
    cFilename=getwwwrootpath("img")+SYS(2015)+"."+JUSTEXT(oFile.oFieldColl.item("file1").filename)
    STRTOFILE(oFile.oFieldColl.item("file1").FieldData,cFilename)
    
    yh1 = VAL(oFile.oFieldColl.item("userid").FieldData)   
    pp1 = oFile.oFieldColl.item("brands").FieldData &&品牌
    bz1 = oFile.oFieldColl.item("remark").FieldData &&备注
    *新增上传图片的信息
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [applypic] (userid,createtime,remark,brands,applypic) VALUES (<<yh1>>,getdate(),'<<bz1>>','<<pp1>>','<<cFilename>>')
	ENDTEXT
	*?lcsqlcmd
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF 
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE apply_agent && 代理商申请
    zsxm1 = httpqueryparams("realname")
    yh1 = httpqueryparams("username")
    sqjb1 = httpqueryparams("agent")
    sj1 = httpqueryparams("phone")
    sjyqr1 = httpqueryparams("p_agent")
    *根据userid获取当前级别和推荐人ID
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT rankid,parentid FROM [user] WHERE LoginName='<<yh1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    dqjb1 = rankid
    tjr1 = parentid
    *申请代理级别
    TEXT TO lcSQLCmd1 NOSHOW TEXTMERGE
	  INSERT INTO [applyrank] (loginName,beforerank,applyrank,parentid,realname,phone,createtime,p_agent) VALUES (<<yh1>>,<<dqjb1>>,'<<sqjb1>>',<<tjr1>>,'<<zsxm1>>','<<sj1>>',getdate(),'<<sjyqr1>>')
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd1)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

ENDDEFINE