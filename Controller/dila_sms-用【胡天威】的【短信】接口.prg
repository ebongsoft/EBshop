CLEAR

*** �á����������ġ����š��ӿڡ�
oXML = Createobject("Microsoft.XMLHTTP")

*** ���ñ�����
sm1="���ã�������������˰������" && �������ݣ�һ��Ҫ��ǩ����
da1="15986989933"  && �ֻ����롣
un1="610441"  && �û���������
pw1="4410718"  && ���룬����
dc1=15  && ��Ϣ���룬��15���ɡ�
rd1=1 && �Ƿ���Ҫ״̬���棬1Ϊ��Ҫ��0Ϊ����Ҫ��
rf1=2  && ���ظ�ʽΪ2��JSON��ʽ��
tf1=3 && �������ݴ�����룬��Ϊ3���ɡ�ΪUTF-8��ʽ��

*** ������䡣����API�ӿڶ�Ӧ��
lcUrl = "http://61.129.57.37:7891/mt?"
oXML.Open("POST", lcUrl, .F.)&&  �������
oXML.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
oXML.setRequestHeader("Content-type", "text/html;charset=UTF-8")
oXML.send("un="+un1+"&pw="+pw1+"&da="+da1+"&sm="+sm1+"&dc=15&rd=1&rf=2&tf=3") 
Rjson1= oXML.responseText && ���ؽ��
?Rjson1