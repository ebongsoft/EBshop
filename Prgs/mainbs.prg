Lparameters cmdLine
*--开发环境 重设默认路径
*!*	If !Inlist(_vfp.StartMode,0)
*!*		On Error Do ResponseError
*!*	Endif

Public connhandle
* 定义公共变量，操作员代码,操作员名,前缀,登录仓库
Public Pc_ID,Pc_NAME,Pc_QZ,Pc_CK
Public Pc_path,Pc_ver
*--开发环境 重设默认路径
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
SQLSetprop(0,"DispLogin",3)  && 不显示SQL登录提示
*--环境设置
Set Exclusive Off   &&共享访问表
Set Century On
Set Date YMD
Set Mark To "-"
Set Deleted On
Set Ansi On
Set Talk Off
Set Safety Off

ofrmMain=Newobject("QiyuLog","qiyulog.prg")
ofrmmain.Log("系统启动"+Version())

Set Library To myfll Additive
*CGI支持
Set Library To fws Additive
*Json支持
Set Library To foxjson.fll Additive
Set Procedure To foxJson Additive
Set Procedure To foxJson_Parse Additive
Set Procedure To qiyuweblib Additive

*USE SYS(2005) AGAIN

*SET RESOURCE OFF
*!*		*--开发环境 不执行下方代码
*!*		If Inlist(_vfp.StartMode,0)
*!*			Return
*!*		Endif

LOCAL oControll,cProc,oCtlObjType
oCtlObjType=""
oControll=CREATEOBJECT("empty")
ADDPROPERTY(oControll,"Name","初始化")
cProc="main" 
*-- 有appuser字段表明调用微信API,否则调用常规过程
&&调用URL为 http://IP/类名.prg?appuser=配置名
&&用户要在wxsetting.dbf里设置
*lcFun=Alltrim(fws_request("fun")) &&根据不同的fun调用不用的类处理

Try
	oHttpcontext=Newobject("HttpContext","HttpContext.prg")
	oFrmMain.Log(oHttpcontext.getAbsoluteUri())

	lcappuser=Alltrim(fws_request("appuser")) &&appuser必传,支持多用户
	m.RequestObject=Juststem(fws_Header("PATH_INFO"))
	m.classfile=m.RequestObject+".prg"
	oFrmMain.Log(RequestObject+"类应答")  &&写入日志
	*--得到参数 调用类方法
	*IF !EMPTY(lcappuser)

	oControll=Newobject(m.RequestObject,m.classfile)
	oCtlObjType=oControll.ParentClass
	*oControll=Newobject(m.RequestObject,m.classfile,"",lcappuser)  && appuser 代表微信API专用类
	cProc=fws_request("proc")
	oFrmMain.log("proc="+cProc)
	*--判断是父类wxapi weixinfsp
	Do Case
		Case Upper(oControll.ParentClass)==Upper("weixinApi")
			If Empty(lcappuser)
				Error "请传入Appuser参数"
			Endif

			oControll.appuser=lcappuser
			cProc="AnswerMsg"

		Case Upper(oControll.ParentClass)=="WEIXINFSP"
			If Empty(lcappuser)
				Error "请传入Appuser参数"
			Endif
			oControll.appuser=lcappuser
			* OTHERWISE
			* oControll=Newobject(m.RequestObject,m.classfile)  && BS框架再考虑了 如果能找到类库，则类执行运算,如果不是，则由默认类去执行
	Endcase
	lcCmd="oControll."+cProc+"()"
	If !Pemstatus(oControll,cProc,5)
		Error m.RequestObject+"."+cProc+"类的方法不存在"
	Endif
	If !Pemstatus(oControll,'iConnid',5)  &&添加一个iConnid属性
		AddProperty(oControll,'iConnid',0)
	Endif
	ofrmmain.Log(oControll.Name+"."+cProc+"开始调用")  &&写入日志

	*--判断是父类wxapi weixinfsp
	Do Case
		Case Upper(oControll.ParentClass)=="WXAPI"
			&lccmd &&执行命令
		Otherwise
			Local RetHtml
			m.RetHtml=Transform(&lccmd)
			*ofrmMain.Log(WebGetUri()+Chr(13)+oControll.Name+"."+cProc+"调用成功")  &&写入日志
			fws_write(m.RetHtml)    &&将处理结果输出给浏览器
			ofrmmain.Log(oControll.Name+"."+cProc+"调用成功")  &&写入日志
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
	ofrmmain.Log(ex.Message+",过程:"+ ex.Procedure+",行号:"+Transform(ex.Lineno))
	RELEASE objall
	RELEASE orow
Endtry
ofrmmain.Log(oControll.Name+"."+cProc+"程序退出")  &&写入日志

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



