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

*!*	  PROCEDURE apply && 上传充值凭证 -------------------------
*!*	    *保存图片
*!*	    oFile=getupfile()
*!*	    cFilename=getwwwrootpath("img")+SYS(2015)+"."+JUSTEXT(oFile.oFieldColl.item("file1").filename)
*!*	    STRTOFILE(oFile.oFieldColl.item("file1").FieldData,cFilename)
*!*	    
*!*	    yh1 = VAL(oFile.oFieldColl.item("userid").FieldData)   
*!*	    pp1 = oFile.oFieldColl.item("brands").FieldData &&品牌
*!*	    bz1 = oFile.oFieldColl.item("remark").FieldData &&备注
*!*	    *新增上传图片的信息
*!*	    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
*!*		  INSERT INTO [applypic] (userid,createtime,remark,brands,applypic) VALUES (<<yh1>>,getdate(),'<<bz1>>','<<pp1>>','<<cFilename>>')
*!*		ENDTEXT
*!*		*?lcsqlcmd
*!*		oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
*!*		IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
*!*		  ERROR oDBSQLHelper.errmsg
*!*		ENDIF 
*!*	    RETURN '{"errno":0,"errmsg":"ok"}'
*!*	  ENDPROC 

  PROCEDURE apply_agent && 代理商申请----------------------------
    yh1 = httpqueryparams("phone")
    zsxm1 = httpqueryparams("realname")
    sqjb1 = httpqueryparams("agent")
    sjyqr1 = httpqueryparams("p_agent")  && 邀请人=推荐人
    sj1 = httpqueryparams("tel")
    *根据userid获取当前级别和推荐人ID
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT rankid FROM [user] WHERE LoginName='<<yh1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    dqjb1 = rankid && 当前级别
    
    *根据wdsj1获取我上级的loginName
    TEXT TO lcSQLCmd2 NOSHOW TEXTMERGE
      SELECT loginName FROM [user] WHERE inviterid=<<sjyqr1>>
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd2,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    sjlogin1 = loginName && 我上级的loginName
    
    *申请代理级别
    TEXT TO lcSQLCmd1 NOSHOW TEXTMERGE
	  INSERT INTO [applyrank] (loginName,beforerank,applyrank,parentid,realname,createtime,phone,sjloginName) VALUES ('<<yh1>>',<<dqjb1>>,'<<sqjb1>>',<<sjyqr1>>,'<<zsxm1>>',getdate(),'<<sj1>>','<<sjlogin1>>')
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd1)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE unapproved  && 显示未审批代理商-------------------------
    yh1 = httpqueryparams("phone")
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT realname,phone,applyrank from [applyrank] WHERE isagree=0 AND sjloginName='<<yh1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"unapproved")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF
    RETURN cursortojson("unapproved")
  ENDPROC 
  
  PROCEDURE agreerank  && 同意推荐人 --------------------------------
    yh1 = httpqueryparams("phone") && 带过来我的账号
    sqr1 = httpqueryparams("realname")
    sqrsj1 = httpqueryparams("tel")
    sqdj1 = httpqueryparams("applyrank")
    
    *查询申请后级别的级别ID
    TEXT TO lcSQLCmd0 NOSHOW TEXTMERGE
      SELECT rankid FROM [rank] WHERE rankname = '<<sqdj1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd0,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    sqrankid1 = rankid  && 申请后的rankid
    
    *修改applyrank表的同意字段
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE  
      UPDATE [applyrank] SET isagree=1,agreetime=getdate() where realname='<<sqr1>>' AND phone='<<sqrsj1>>'
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	

	*找出同意字段的loginName
    TEXT TO lcSQLCmd1 NOSHOW TEXTMERGE
      SELECT loginName FROM [applyrank] WHERE realname='<<sqr1>>' AND phone='<<sqrsj1>>'
	ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd1,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    sqrzh1 = loginName && 申请人的loginName
	
    *修改用户表的等级
    TEXT TO lcSQLCmd2 NOSHOW TEXTMERGE
      UPDATE [user] SET rankid=<<sqrankid1>>,realname='<<sqr1>>' where loginName='<<sqrzh1>>'
    ENDTEXT	
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd2)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    	
	RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

ENDDEFINE