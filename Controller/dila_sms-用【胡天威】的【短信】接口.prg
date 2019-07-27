CLEAR

*** 用【胡天威】的【短信】接口。
oXML = Createobject("Microsoft.XMLHTTP")

*** 设置变量。
sm1="您好，我是礼初。【宜邦软件】" && 短信内容，一定要加签名。
da1="15986989933"  && 手机号码。
un1="610441"  && 用户名，必填
pw1="4410718"  && 密码，必填
dc1=15  && 消息编码，用15即可。
rd1=1 && 是否需要状态报告，1为需要，0为不需要。
rf1=2  && 返回格式为2，JSON格式。
tf1=3 && 短信内容传输编码，设为3即可。为UTF-8格式。

*** 发送语句。（与API接口对应）
lcUrl = "http://61.129.57.37:7891/mt?"
oXML.Open("POST", lcUrl, .F.)&&  发送语句
oXML.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
oXML.setRequestHeader("Content-type", "text/html;charset=UTF-8")
oXML.send("un="+un1+"&pw="+pw1+"&da="+da1+"&sm="+sm1+"&dc=15&rd=1&rf=2&tf=3") 
Rjson1= oXML.responseText && 返回结果
?Rjson1