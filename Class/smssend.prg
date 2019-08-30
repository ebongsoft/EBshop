*!*	中国网建 http://sms.webchinese.cn/api_Up.shtml
*!*	GBK编码发送接口地址：  http://gbk.api.smschinese.cn/?Uid=本站用户名&Key=接口安全秘钥&smsMob=手机号码&smsText=验证码:8888  
*!*	Uid      	本站用户名（如您无本站用户名请先注册）[免费注册]
*!*	Key         注册时填写的接口秘钥（可到用户平台修改接口秘钥）[立刻修改],如需要加密参数，请把Key变量名改成KeyMD5，KeyMD5=接口秘钥32位MD5加密，大写。
*!*	smsMob      目的手机号码（多个手机号请用半角逗号隔开）
*!*	smsText 	短信内容，最多支持400个字，普通短信70个字/条，长短信64个字/条计费

*!*	证码请做好以下几点防范：
*!*	发送验证码1分钟只能点击发送1次；
*!*	相同IP手机号码1天最多提交20次；
*!*	验证码短信单个手机号码30分钟最多提交10次；
*!*	在提交页面加入图形校验码，防止机器人恶意发送；
*!*	在发送验证码接口程序中，判断图形校验码输入是否正确；
*!*	新用户用接口测试验证码时，请勿输入：测试等无关内容信息，请直接输入：验证码:xxxxxx，发送。
*!*	接口发送触发短信时，您可以把短信内容提供给客服绑定短信模板，绑定后24小时即时发送。未绑定模板的短信21点以后提交，隔天才能收到。

*** 在界面添加浏览器。
Clear
*!*    oXML = Createobject("WinHttp.WinHttpRequest.5.1") &&  XP或者98只能调用老版本的5.1浏览器内核。
oXML = Createobject("Microsoft.XMLHTTP")

*** 设置变量。
key1 = "5ee2e6487b823965556e"   && 密钥 
uid1 = "ebong1"               && 登陆账号
smsMob1  = ALLTRIM(thisform.text1.value) && 接收信息的号码    例如："15986989933"
smsText1 = ALLTRIM(thisform.edit1.value) &&+ALLTRIM(thisform.text2.value)  && 发送内容    例如：  "【宜邦软件】我是连武宜，这是我用VF开发的发送手机内容！"

*** 发送语句。（与API接口对应）
lcUrl = "http://gbk.api.smschinese.cn/?" + "Uid=" + uid1 + "&" + "key=" + key1 + "&" + "smsMob=" + smsMob1 + "&" + "smsText=" + smsText1
oXML.Open("POST", lcUrl, .F.)&&  发送语句

PostData  = " " + Chr(13) + Chr(10)

oXML.setRequestHeader("Content-Length", Len(PostData))
oXML.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
oXML.setRequestHeader("Content-type", "text/xml;charset=gb2312")

oXML.Send(PostData)

Do While oXML.ReadyState <> 4
    =Inkey(1)
ENDDO

Do Case
    Case oXML.Status = 200  && 请求被服务器正确相应
    Case oXML.Status = 500  && 服务器内部错误 "PostData 数据错误，或服务器内部错误"
    Case oXML.Status = 404  && 路径错 "路径出错，找不到"
    Case oXML.Status = -3	&& 短信数量不足
    Case oXML.Status = -11	&& 该用户被禁用
    Case oXML.Status = -14	&& 短信内容出现非法字符
    Case oXML.Status = -51	&& 短信签名格式不正确，接口签名格式为：【签名内容】
    Case oXML.Status = -6	&& IP限制
    Otherwise               && "其他错误"
Endcase

Release oXML
oXML = Null

thisform.Refresh 