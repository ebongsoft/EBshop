* �ɹ��� -------------------------------------------------

DEFINE CLASS cgd As Session

	PROCEDURE cgdbt && ��ʾ�ɹ���δ�����ĵ�
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && ����Դ�
      IF oDBSQLhelper.SQLQuery("select �ɹ�����id,����Ա,������ from cgdd where ������<>'ͬ��' GROUP BY �ɹ�����id,����Ա,������","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC 

	PROCEDURE cgdnr && δ�������ݵ� ���� 
	  cgdid1=httpqueryparams("cgdid") && ,this.iconnid
	  
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    SELECT ������,��Ӧ������,��������,�µ�����,���ʽ,�ͻ�����,SUM(�ɹ����) as �ɹ���� from cgdd where �ɹ�����id=<<cgdid1>> group by ������,��Ӧ������,��������,�µ�����,���ʽ,�ͻ����� 
	  ENDTEXT
 	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	  IF oDBSQLhelper.SQLQuery(lcSQLCmd,"tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
      RETURN cursortojson("tmp")
    ENDPROC 
      
    PROCEDURE cgdmx && �ɹ���������ϸ
      cgdid1=httpqueryparams("cgdid") && ,this.iconnid
	  TEXT TO lcsqlcmd1 TEXTMERGE NOSHOW PRETEXT 3
		select ���,��Ʒ����,��Ʒ����,����,��λ,�ɹ�����,�ɹ�����,�ɹ���� from cgdd where �ɹ�����id=<<cgdid1>>
	  ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.SQLQuery(lcSQLCmd1,"tmp1")<0
		ERROR ODBSQLHELPER.errmsg
	  ENDIF
	  RETURN cursortojson("tmp1")
    ENDPROC
	
	PROCEDURE cgdspSave && ��������ͬ��
	  ddh1=HttpQueryParams("cgdid")
		
	  TEXT TO lcSQLCmd NOSHOW TEXTMERGE
	    UPDATE cgdd SET �����='��ΰ��',������='ͬ��' where �ɹ�����id=<<ddh1>>
	  ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd)<0
		ERROR oDBSQLHelper.errmsg
	  ENDIF
	  RETURN '{"errno":0,"errmsg":"ok"}'
    ENDPROC
	
	PROCEDURE cgdbtmonth && ��ʾ�ɹ��������¡��ĵ�
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && ����Դ�
      IF oDBSQLhelper.SQLQuery("SELECT �ɹ�����id,����Ա,������ from cgdd where DateDiff(month,[�µ�����],getdate())=0 GROUP BY �ɹ�����id,����Ա,������","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC 	

	PROCEDURE cgdbtweek && ��ʾ�ɹ��������ܡ��ĵ�
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && ����Դ�
      IF oDBSQLhelper.SQLQuery("SELECT �ɹ�����id,����Ա,������ from cgdd where DateDiff(week,[�µ�����],getdate())=0 GROUP BY �ɹ�����id,����Ա,������","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC 	

	PROCEDURE cgdbtdd && ��ʾ�ɹ��������졿�ĵ�
	  oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") && ����Դ�
      IF oDBSQLhelper.SQLQuery("SELECT �ɹ�����id,����Ա,������ from cgdd where DateDiff(dd,[�µ�����],getdate())=0 GROUP BY �ɹ�����id,����Ա,������","tmp")<0
	    ERROR oDBSQLhelper.errmsg
	  ENDIF 
	  RETURN cursortojson("tmp")
	ENDPROC
	
ENDDEFINE 