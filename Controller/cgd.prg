* 采购单 -------------------------------------------------

DEFINE CLASS cgd As Session

	PROCEDURE cgdbt && 显示采购单未审批的单
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && 框架自带
      IF oDBSQLhelper.SQLQuery("select 采购订单id,操作员,审核意见 from cgdd where 审核意见<>'同意' GROUP BY 采购订单id,操作员,审核意见","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC 

	PROCEDURE cgdnr && 未审批单据单 内容 
	  cgdid1=httpqueryparams("cgdid") && ,this.iconnid
	  
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    SELECT 订单号,供应商名称,交货日期,下单日期,付款方式,客户名称,SUM(采购金额) as 采购金额 from cgdd where 采购订单id=<<cgdid1>> group by 订单号,供应商名称,交货日期,下单日期,付款方式,客户名称 
	  ENDTEXT
 	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	  IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
      RETURN cursortojson("tmp")
    ENDPROC 
      
    PROCEDURE cgdmx && 采购单单据明细
      cgdid1=httpqueryparams("cgdid") && ,this.iconnid
	  TEXT TO lcsqlcmd1 TEXTMERGE NOSHOW PRETEXT 3
		select 序号,产品名称,产品编码,材料,单位,采购数量,采购单价,采购金额 from cgdd where 采购订单id=<<cgdid1>>
	  ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.SQLQuery(lcSQLCmd1,"tmp1")<0
		ERROR ODBSQLHELPER.errmsg
	  ENDIF
	  RETURN cursortojson("tmp1")
    ENDPROC
	
	PROCEDURE cgdspSave && 保存审批同意
	  ddh1=HttpQueryParams("cgdid")
		
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    UPDATE cgdd SET 审核人='陶伟荣',审核意见='同意' where 采购订单id=<<ddh1>>
	  ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
		ERROR oDBSQLHelper.errmsg
	  ENDIF
	  RETURN '{"errno":0,"errmsg":"ok"}'
    ENDPROC
	
	PROCEDURE cgdbtmonth && 显示采购单【本月】的单
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && 框架自带
      IF oDBSQLhelper.SQLQuery("SELECT 采购订单id,操作员,审核意见 from cgdd where DateDiff(month,[下单日期],getdate())=0 GROUP BY 采购订单id,操作员,审核意见","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC 	

	PROCEDURE cgdbtweek && 显示采购单【本周】的单
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && 框架自带
      IF oDBSQLhelper.SQLQuery("SELECT 采购订单id,操作员,审核意见 from cgdd where DateDiff(week,[下单日期],getdate())=0 GROUP BY 采购订单id,操作员,审核意见","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC 	

	PROCEDURE cgdbtdd && 显示采购单【当天】的单
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && 框架自带
      IF oDBSQLhelper.SQLQuery("SELECT 采购订单id,操作员,审核意见 from cgdd where DateDiff(dd,[下单日期],getdate())=0 GROUP BY 采购订单id,操作员,审核意见","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC
	
ENDDEFINE 