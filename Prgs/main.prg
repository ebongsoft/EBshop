Set Talk Off
Set Safety Off
Set Century On
SET ESCAPE OFF
Set Date Ansi
*Close All
*ON SHUTDOWN do quits
Public connhandle
* ���幫������������Ա����,����Ա��,ǰ׺,��¼�ֿ�
Public Pc_ID,Pc_NAME,Pc_QZ,Pc_CK
Public Pc_path,Pc_ver
*--�������� ����Ĭ��·��
If Inlist(_vfp.StartMode,0)
	*Pc_path=Justpath(Sys(16))
	Pc_path = Justpath(_vfp.ActiveProject.Name)
	Set Default To (Pc_path)
Endif

Pc_path=Sys(5)+Sys(2003)+"\"
Set Default To (Pc_path)
Set Path To Menus;prgs;Forms;Class;Images;dll;Report;Database;DAL;BLL;otherclass
Set Path To [WebAPIframework] Additive
SQLSETPROP(0,"DispLogin",3)  && ����ʾSQL��¼��ʾ

*-- Do form     &&��������

*--   ���л��� ����Events
If !Inlist(_vfp.StartMode,0)
   *DO FORM main_form
   READ EVENTS
Endif

