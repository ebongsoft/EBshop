DEFINE CLASS dila_machine as Session

  PROCEDURE runmachine  
    *LOCATE zhid1,bh1,sc1,je1,ms1,zh1,my1,fwqbm1,token1,zt1
    *** ��ȡ����
    yh1=httpqueryparams("phone") && �˻�ID
    bh1=httpqueryparams("code")  && �������
    
    *** ��machine ��ѯ�����˻���Ϣ-------------------------
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT * FROM machine WHERE code='<<bh1>>'
    ENDTEXT
    oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"machine")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF 
    SELECT machine
    GO TOP 
    sc1=timer && ����ʱ����ֵ���ܳ���1440

    *** ��account��ѯ�˻���Ϣ-------------------------------------
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") 
    IF oDBSQLhelper.SQLQuery("select * from account","account")<0
	  ERROR oDBSQLhelper.errmsg
    ENDIF 
    SELECT account
    GO TOP 
    zh1 = ALLTRIM(account)
    my1 = ALLTRIM(md5key)  && ALLTRIM(MD5(ALLTRIM(key))) && ����Կ��MD5��ʽ���ܣ�
    fwqbm1 = ALLTRIM(num)
    *RETURN cursortojson("account")
    
    *** ��ѯ�˻�����Ƿ���㣬
	TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT times FROM [user] WHERE loginName='<<yh1>>'
    ENDTEXT
    oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"user")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF 
    SELECT user
    GO TOP 
    ye1 = times
	IF ye1=0
	  ERROR "�˻����������㣬���ֵ"
	ENDIF 

	*** ����ȡtoken��------------------------------------------
	cUrl="https://twwl.sailafeinav.com/shemachineapi/gettoken/"
	xmlhttp=Createobject("Microsoft.XMLHTTP")
	xmlhttp.Open("POST", ALLTRIM(cUrl), .F.)
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	xmlhttp.send("account="+zh1+"&key="+my1)
    cJson = xmlhttp.responseText && �������������ݸ�ֵ��cJson��
	oJSON=foxjson_parse(cJson)
	token1 = ALLTRIM(oJson.item("token"))	
    *RETURN token1

     *** ����ȡ����״̬states��------------------------------
	cUrl="https://twwl.sailafeinav.com/shemachineapi/states/"
	xmlhttp=Createobject("Microsoft.XMLHTTP")
	xmlhttp.Open("POST", ALLTRIM(cUrl), .F.)
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    xmlhttp.send("token="+token1+"&account="+zh1+"&num="+fwqbm1+"&code="+bh1+"&type=one") 
    cJson1 = xmlhttp.responseText && �������������ݸ�ֵ��cJson��  
    *RETURN cjson1
	oJSON1=foxjson_parse(cJson1)
    zt1=ALLTRIM(oJSON1.item("states").item(1))  && ��ȡ״̬��
	DO CASE 
	  CASE zt1="run"
	  ERROR "������������"
	  CASE zt1="noreg"
	  ERROR "������Ų�����"
	  CASE zt1="error"
	  ERROR "����û������Ҳû������"
*!*	      CASE zt1="link" && 
*!*	      ERROR "�����Ѿ�����"
	ENDCASE 

    *** ����������runmachine��-----------------------------------
	cUrl="https://twwl.sailafeinav.com/shemachineapi/runmachine/"
	xmlhttp=Createobject("Microsoft.XMLHTTP")
	xmlhttp.Open("POST", ALLTRIM(cUrl), .F.)
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    xmlhttp.send("token="+token1+"&account="+zh1+"&num="+fwqbm1+"&code="+bh1+"&timer="+ALLTRIM(STR(sc1))) 
    cJson2 = xmlhttp.responseText && �������������ݸ�ֵ��cJson�� 
    * RETURN cJson2 && �ɹ�����   {"msg":"success","code":1}
	oJSON1=foxjson_parse(cJson2)
    cg1=oJSON1.item("code")  && ��ȡ״̬��    

    IF cg1=1
      ** ȥuser������
	  TEXT TO lcSQLCmd1 NOSHOW TEXTMERGE
        UPDATE [user] SET times = times-1 WHERE loginName='<<yh1>>'
      ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
      IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd1)<0
	    ERROR oDBSQLHelper.errmsg
	  ENDIF

	  ** �������Ѽ�¼
	  TEXT TO lcSQLCmd2 NOSHOW TEXTMERGE
        INSERT INTO moneys (datasrc,moneytype,loginName,code,createtime,type) VALUES (2,0,'<<yh1>>','<<bh1>>',getdate(),0)
      ENDTEXT
	  oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
	  IF oDBSQLhelper.ExeCuteSQL(lcSQLCmd2)<0
	    ERROR oDBSQLHelper.errmsg
	  ENDIF
    
      RETURN '{"errno":0,"errmsg":"ok"}'
    ELSE
      ERROR "����ʧ��"
    ENDIF 
    
  ENDPROC

  PROCEDURE restartmachine  
    *** ��ȡ����
    bh1=httpqueryparams("code")  && �������
    
    *** ��machine ��ѯ�����˻���Ϣ-------------------------
    TEXT TO lcSQLCmd NOSHOW TEXTMERGE
      SELECT * FROM machine WHERE code='<<bh1>>'
    ENDTEXT
    oDBSQLhelper=NEWOBJECT("MSSQLhelper","MSSQLhelper.prg")
 	IF oDBSQLhelper.SQLQuery(lcSQLCmd,"machine")<0
	  ERROR oDBSQLhelper.errmsg
	ENDIF 
    SELECT machine
    GO TOP 
    sc1=0 && timer && ����ʱ����ֵ���ܳ���1440
          
    *** ��account��ѯ�˻���Ϣ-------------------------------------
	oDBSQLhelper=NEWOBJECT("MSSQLHelper","MSSQLHelper.prg") 
    IF oDBSQLhelper.SQLQuery("select * from account","account")<0
	  ERROR oDBSQLhelper.errmsg
    ENDIF 
    SELECT account
    GO TOP 
    zh1 = ALLTRIM(account)
    my1 = ALLTRIM(md5key)  && ALLTRIM(MD5(ALLTRIM(key))) && ����Կ��MD5��ʽ���ܣ�
    fwqbm1 = ALLTRIM(num)
    *RETURN cursortojson("account")

	*** ����ȡtoken��------------------------------------------
	cUrl="https://twwl.sailafeinav.com/shemachineapi/gettoken/"
	xmlhttp=Createobject("Microsoft.XMLHTTP")
	xmlhttp.Open("POST", ALLTRIM(cUrl), .F.)
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	xmlhttp.send("account="+zh1+"&key="+my1)
    cJson = xmlhttp.responseText && �������������ݸ�ֵ��cJson��
	oJSON=foxjson_parse(cJson)
	token1 = ALLTRIM(oJson.item("token"))	
    *RETURN token1

    *** ����������restartmachine��-----------------------------------
	cUrl="https://twwl.sailafeinav.com/shemachineapi/runmachine/"
	xmlhttp=Createobject("Microsoft.XMLHTTP")
	xmlhttp.Open("POST", ALLTRIM(cUrl), .F.)
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    xmlhttp.send("token="+token1+"&account="+zh1+"&num="+fwqbm1+"&code="+bh1+"&timer="+ALLTRIM(STR(sc1))) 
    cJson2 = xmlhttp.responseText && �������������ݸ�ֵ��cJson�� 
    * RETURN cJson2 && �ɹ�����   {"msg":"success","code":1}
	oJSON1=foxjson_parse(cJson2)
    cg1=oJSON1.item("code")  && ��ȡ״̬��    
    IF cg1=1
      RETURN '{"errno":0,"errmsg":"ok"}'
    ELSE
      ERROR "��������ʧ��"
    ENDIF 
    	    
  ENDPROC

ENDDEFINE 