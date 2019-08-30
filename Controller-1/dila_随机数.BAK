*!*		DO WHILE .T.
	    *** 生成一个随机6位数，并检查是否重复，不重复则变成邀请码
	    sjs1='888888'&& INT(RAND()*900000)+100000 && 6位随机数
		oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
		sjsss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [user] WHERE inviterid='{1}'",sjs1))
		RETURN sjsss1
*!*			IF ss1=0 && 数据存在，再继续生成
*!*			  EXIT 
*!*			ENDIF 
*!*		ENDDO 
	
	RETURN '随机数产生OK'
	
	
	
					
				    *保存用户充值信息
				    yh1 = httpqueryparams("phone")
				*!*	    pt1 = httpqueryparams("paytype") && 支付的平台
				*!*	    DO CASE 
				*!*	      CASE lnje = 299
				*!*	      cs1 = 10
				*!*	      CASE lnje = 1280
				*!*	      cs1 = 50
				*!*	      CASE lnje = 5380
				*!*	      cs1 = 999
				*!*	      CASE pt1 = 2 && 如果是电商平台，次数就为0
				*!*	      cs1 = 0
				*!*	    ENDCASE 
				    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
					  INSERT INTO [moneys] (datasrc,moneytype,money,loginName,createtime) VALUES (1,1,<<lnje>>,'<<yh1>>',getdate())
					ENDTEXT
					oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
					IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
					  ERROR oDBSQLHelper.errmsg
					ENDIF    
				    *修改用户余额表
				    TEXT TO lcSQLCmd1 NOSHOW TEXTMERGE
					  UPDATE [user] SET balance = balance+<<lnje>> where loginName=<<yh1>>
					ENDTEXT
					oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
					IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd1)<0
					  ERROR oDBSQLHelper.errmsg
					ENDIF   
				
				