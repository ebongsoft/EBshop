*!*	�й����� http://sms.webchinese.cn/api_Up.shtml
*!*	GBK���뷢�ͽӿڵ�ַ��  http://gbk.api.smschinese.cn/?Uid=��վ�û���&Key=�ӿڰ�ȫ��Կ&smsMob=�ֻ�����&smsText=��֤��:8888  
*!*	Uid      	��վ�û����������ޱ�վ�û�������ע�ᣩ[���ע��]
*!*	Key         ע��ʱ��д�Ľӿ���Կ���ɵ��û�ƽ̨�޸Ľӿ���Կ��[�����޸�],����Ҫ���ܲ��������Key�������ĳ�KeyMD5��KeyMD5=�ӿ���Կ32λMD5���ܣ���д��
*!*	smsMob      Ŀ���ֻ����루����ֻ������ð�Ƕ��Ÿ�����
*!*	smsText 	�������ݣ����֧��400���֣���ͨ����70����/����������64����/���Ʒ�

*!*	֤�����������¼��������
*!*	������֤��1����ֻ�ܵ������1�Σ�
*!*	��ͬIP�ֻ�����1������ύ20�Σ�
*!*	��֤����ŵ����ֻ�����30��������ύ10�Σ�
*!*	���ύҳ�����ͼ��У���룬��ֹ�����˶��ⷢ�ͣ�
*!*	�ڷ�����֤��ӿڳ����У��ж�ͼ��У���������Ƿ���ȷ��
*!*	���û��ýӿڲ�����֤��ʱ���������룺���Ե��޹�������Ϣ����ֱ�����룺��֤��:xxxxxx�����͡�
*!*	�ӿڷ��ʹ�������ʱ�������԰Ѷ��������ṩ���ͷ��󶨶���ģ�壬�󶨺�24Сʱ��ʱ���͡�δ��ģ��Ķ���21���Ժ��ύ����������յ���

*** �ڽ�������������
Clear
*!*    oXML = Createobject("WinHttp.WinHttpRequest.5.1") &&  XP����98ֻ�ܵ����ϰ汾��5.1������ںˡ�
oXML = Createobject("Microsoft.XMLHTTP")

*** ���ñ�����
key1 = "5ee2e6487b823965556e"   && ��Կ 
uid1 = "ebong1"               && ��½�˺�
smsMob1  = ALLTRIM(thisform.text1.value) && ������Ϣ�ĺ���    ���磺"15986989933"
smsText1 = ALLTRIM(thisform.edit1.value) &&+ALLTRIM(thisform.text2.value)  && ��������    ���磺  "���˰���������������ˣ���������VF�����ķ����ֻ����ݣ�"

*** ������䡣����API�ӿڶ�Ӧ��
lcUrl = "http://gbk.api.smschinese.cn/?" + "Uid=" + uid1 + "&" + "key=" + key1 + "&" + "smsMob=" + smsMob1 + "&" + "smsText=" + smsText1
oXML.Open("POST", lcUrl, .F.)&&  �������

PostData  = " " + Chr(13) + Chr(10)

oXML.setRequestHeader("Content-Length", Len(PostData))
oXML.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
oXML.setRequestHeader("Content-type", "text/xml;charset=gb2312")

oXML.Send(PostData)

Do While oXML.ReadyState <> 4
    =Inkey(1)
ENDDO

Do Case
    Case oXML.Status = 200  && ���󱻷�������ȷ��Ӧ
    Case oXML.Status = 500  && �������ڲ����� "PostData ���ݴ��󣬻�������ڲ�����"
    Case oXML.Status = 404  && ·���� "·�������Ҳ���"
    Case oXML.Status = -3	&& ������������
    Case oXML.Status = -11	&& ���û�������
    Case oXML.Status = -14	&& �������ݳ��ַǷ��ַ�
    Case oXML.Status = -51	&& ����ǩ����ʽ����ȷ���ӿ�ǩ����ʽΪ����ǩ�����ݡ�
    Case oXML.Status = -6	&& IP����
    Otherwise               && "��������"
Endcase

Release oXML
oXML = Null

thisform.Refresh 