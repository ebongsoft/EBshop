Set Talk Off
Set Safety Off
Set Century On
SET ESCAPE OFF
Set Date Ansi
*Close All
*ON SHUTDOWN do quits
Public connhandle
* 定义公共变量，操作员代码,操作员名,前缀,登录仓库
Public Pc_ID,Pc_NAME,Pc_QZ,Pc_CK
Public Pc_path,Pc_ver
*--开发环境 重设默认路径
If Inlist(_vfp.StartMode,0)
	*Pc_path=Justpath(Sys(16))
	Pc_path = Justpath(_vfp.ActiveProject.Name)
	Set Default To (Pc_path)
Endif

Pc_path=Sys(5)+Sys(2003)+"\"
Set Default To (Pc_path)
Set Path To Menus;prgs;Forms;Class;Images;dll;Report;Database;DAL;BLL;otherclass
Set Path To [WebAPIframework] Additive
SQLSETPROP(0,"DispLogin",3)  && 不显示SQL登录提示

*-- Do form     &&调用主表单

*--   运行环境 启用Events
If !Inlist(_vfp.StartMode,0)
   *DO FORM main_form
   READ EVENTS
Endif

