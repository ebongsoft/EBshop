* �����̳��û���ַ����-----------------

DEFINE CLASS dila_address as Session 

  PROCEDURE map && ��ʾ�ջ��˵�ַ-------------------------
    yh1 = httpqueryparams("tel")
    *��ѯ�ҵ��ջ���ַ
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT username,userphone,area,useraddress,addressid from address where loginName='<<yh1>>' 
    ENDTEXT
 	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
      ERROR oDBSQLhelper.errmsg
    ENDIF 
    RETURN cursortojson("tmp")
  ENDPROC 

  PROCEDURE newaddress && �����ջ��˵�ַ-------------------------
    yh1 = httpqueryparams("tel")
    yhmc1 = httpqueryparams("username")
    qy1 = httpqueryparams("area")
    xxdz1 = httpqueryparams("address")
    lxdh1 = httpqueryparams("userphone")
    *��ѯ�Ƿ���Ĭ�ϵ�ַ
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg")
	ss1 = oDBSQLhelper.GetSingle(stringformat("SELECT COUNT(*) FROM [address] WHERE isdefault=1 and loginName='{1}'",yh1))
	IF ss1<=0
	  mrdz1 = 1 && û��Ĭ�ϵ�ַ����ǰΪĬ�ϵ�ַ
	ELSE 
	  mrdz1 = 0 && ��Ĭ�ϵ�ַ������������ȥ�޸�
	ENDIF 
    *������ַ��Ϣ
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  INSERT INTO [address] (loginName,username,area,useraddress,userphone,createtime,isdefault) VALUES (<<yh1>>,'<<yhmc1>>','<<qy1>>','<<xxdz1>>','<<lxdh1>>',getdate(),<<mrdz1>>)
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

  PROCEDURE editaddress && �޸��ջ��˵�ַ-------------------------
    id1 = httpqueryparams("addressid")
    yh1 = httpqueryparams("tel")
    yhmc1 = httpqueryparams("username")
    qy1 = httpqueryparams("area")
    xxdz1 = httpqueryparams("address")
    lxdh1 = httpqueryparams("userphone")
    mrdz1 = httpqueryparams("isdefault")
    IF VAL(mrdz1)=1 && ����û��޸ĵ�ǰ����ΪĬ��
	  *��ȫ��Ĭ��ֵ����Ϊ0
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    UPDATE [address] SET isdefault=0 WHERE loginName='<<yh1>>'
	  ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	    ERROR oDBSQLHelper.errmsg
	  ENDIF	
    ENDIF 
    *�޸ĵ�ַ��Ϣ
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	   UPDATE [address] SET username='<<yhmc1>>',area='<<qy1>>',useraddress='<<xxdz1>>',userphone='<<lxdh1>>',isdefault=<<mrdz1>> WHERE addressid = <<id1>> 
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
    IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}' 
  ENDPROC 
  
  
  PROCEDURE deladdress && ɾ���ջ��˵�ַ-------------------------
    id1 = httpqueryparams("addressid")
    *ɾ����ַ��Ϣ
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	  DELETE FROM [address] WHERE addressid = <<id1>>
	ENDTEXT
	oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
	  ERROR oDBSQLHelper.errmsg
	ENDIF	
    RETURN '{"errno":0,"errmsg":"ok"}'
  ENDPROC 

ENDDEFINE 