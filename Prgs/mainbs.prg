Lparameters cmdLine
*--�������� ����Ĭ��·��
*!*	If !Inlist(_vfp.StartMode,0)
*!*		On Error Do ResponseError
*!*	Endif

Public connhandle
* ���幫������������Ա����,����Ա��,ǰ׺,��¼�ֿ�
Public Pc_ID,Pc_NAME,Pc_QZ,Pc_CK
Public Pc_path,Pc_ver
*--�������� ����Ĭ��·��
If Inlist(_vfp.StartMode,0)
	*Pc_path=Justpath(Sys(16))
	Pc_path =Addbs(Justpath(_vfp.ActiveProject.Name))
	Set Default To (Pc_path)
Else
	Pc_path=Sys(5)+Sys(2003)+"\"
	Set Default To (Pc_path)
Endif

Set Path To Addbs(_vfp.ServerName)
Set Path To Menus;prgs;Forms;Class;Images;Dll;Report;Database;DAL;BLL;Model;Wxapi;WxClientApi;msgclass
Set Path To [WebAPIframework] Additive
Set Path To [Controller] Additive
SQLSetprop(0,"DispLogin",3)  && ����ʾSQL��¼��ʾ
*--��������
Set Exclusive Off   &&������ʱ�
Set Century On
Set Date YMD
Set Mark To "-"
Set Deleted On
Set Ansi On
Set Talk Off
Set Safety Off

ofrmMain=Newobject("QiyuLog","qiyulog.prg")
ofrmmain.Log("ϵͳ����"+Version())

Set Library To myfll Additive
*CGI֧��
Set Library To fws Additive
*Json֧��
Set Library To foxjson.fll Additive
Set Procedure To foxJson Additive
Set Procedure To foxJson_Parse Additive
Set Procedure To qiyuweblib Additive

*USE SYS(2005) AGAIN

*SET RESOURCE OFF
*!*		*--�������� ��ִ���·�����
*!*		If Inlist(_vfp.StartMode,0)
*!*			Return
*!*		Endif

LOCAL oControll,cProc,oCtlObjType
oCtlObjType=""
oControll=CREATEOBJECT("empty")
ADDPROPERTY(oControll,"Name","��ʼ��")
cProc="main" 
*-- ��appuser�ֶα�������΢��API,������ó������
&&����URLΪ http://IP/����.prg?appuser=������
&&�û�Ҫ��wxsetting.dbf������
*lcFun=Alltrim(fws_request("fun")) &&���ݲ�ͬ��fun���ò��õ��ദ��

Try
	oHttpcontext=Newobject("HttpContext","HttpContext.prg")
	oFrmMain.Log(oHttpcontext.getAbsoluteUri())

	lcappuser=Alltrim(fws_request("appuser")) &&appuser�ش�,֧�ֶ��û�
	m.RequestObject=Juststem(fws_Header("PATH_INFO"))
	m.classfile=m.RequestObject+".prg"
	oFrmMain.Log(RequestObject+"��Ӧ��")  &&д����־
	*--�õ����� �����෽��
	*IF !EMPTY(lcappuser)

	oControll=Newobject(m.RequestObject,m.classfile)
	oCtlObjType=oControll.ParentClass
	*oControll=Newobject(m.RequestObject,m.classfile,"",lcappuser)  && appuser ����΢��APIר����
	cProc=fws_request("proc")
	oFrmMain.log("proc="+cProc)
	*--�ж��Ǹ���wxapi weixinfsp
	Do Case
		Case Upper(oControll.ParentClass)==Upper("weixinApi")
			If Empty(lcappuser)
				Error "�봫��Appuser����"
			Endif

			oControll.appuser=lcappuser
			cProc="AnswerMsg"

		Case Upper(oControll.ParentClass)=="WEIXINFSP"
			If Empty(lcappuser)
				Error "�봫��Appuser����"
			Endif
			oControll.appuser=lcappuser
			* OTHERWISE
			* oControll=Newobject(m.RequestObject,m.classfile)  && BS����ٿ����� ������ҵ���⣬����ִ������,������ǣ�����Ĭ����ȥִ��
	Endcase
	lcCmd="oControll."+cProc+"()"
	If !Pemstatus(oControll,cProc,5)
		Error m.RequestObject+"."+cProc+"��ķ���������"
	Endif
	If !Pemstatus(oControll,'iConnid',5)  &&���һ��iConnid����
		AddProperty(oControll,'iConnid',0)
	Endif
	ofrmmain.Log(oControll.Name+"."+cProc+"��ʼ����")  &&д����־

	*--�ж��Ǹ���wxapi weixinfsp
	Do Case
		Case Upper(oControll.ParentClass)=="WXAPI"
			&lccmd &&ִ������
		Otherwise
			Local RetHtml
			m.RetHtml=Transform(&lccmd)
			*ofrmMain.Log(WebGetUri()+Chr(13)+oControll.Name+"."+cProc+"���óɹ�")  &&д����־
			fws_write(m.RetHtml)    &&������������������
			ofrmmain.Log(oControll.Name+"."+cProc+"���óɹ�")  &&д����־
	Endcase

Catch To ex
	objall=Createobject("foxjson")
	objall.Append("errno",ex.ErrorNo)
	objall.Append("errmsg",ex.Message)
	objall.Append("success","false")
	objall.Append("errorMsg",ex.Message)
	objall.Append("total",0)
	orow=Createobject("foxjson",{})
	objall.Append("rows",orow.tostring())	
	If Upper(oCtlObjType)!="WXAPI"
		fws_write(objall.tostring())
	ENDIF
	ofrmmain.Log(ex.Message+",����:"+ ex.Procedure+",�к�:"+Transform(ex.Lineno))
	RELEASE objall
	RELEASE orow
Endtry
ofrmmain.Log(oControll.Name+"."+cProc+"�����˳�")  &&д����־

RELEASE ofrmmain
RELEASE oCtlObjType
SET PROCEDURE TO
*!*	Catch To ex
*!*		*Strtofile(ex.Message,"error.txt")
*!*		cFilename="error.txt"
*!*		If Empty(cFilename)
*!*			cFilename=Dtoc(Date())+".txt"
*!*		Endif
*!*		cMsg=Ttoc(Datetime())+" "+ex.Message+Chr(13)+Chr(10)
*!*		Strtofile(cMsg,cFilename,1)
*!*	Endtry
Set Library To
Close All
Quit



