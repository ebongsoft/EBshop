
《微信小程序商城开发实战》随书资料说明


注意小程序必须要用HTTPS请求，一般需要：1、拥有一台云服务器，2、拥有一个ICP备案域名，3、申请SSL证书，4、Apache或Nginx配置HTTPS



小程序后端代码文件夹为backend，使用说明如下：

1.到网站后台小程序配置填写微信小程序的相关资料

2.修改App/Common/Conf/db.php 数据库连接参数

3.修改App/Api/Conf/config.php 微信小程序的appid、secret、mchid、key、notify_url，SELF_ROOT的参数

4.修改ThinkPHP\Library\Vendor\wxpay\lib\WxPay.Config.php 微信小程序的appid、appsecret、mchid、key参数

5.修改ThinkPHP\Library\Vendor\WeiXinpay\lib\WxPay.Config.php 微信小程序的appid、appsecret、mchid、key、notify_url参数

6.修改App/Api/Controller/WxPayController.class.php 67行链接，$input->SetNotify_url('修改链接')

7.上传你的支付文件证书到/ThinkPHP/Library/Vendor/WeiXinpay/cert/目录 及 /ThinkPHP/Library/Vendor/wxpay/cert/ 这个目录下




小程序前端代码文件夹为mini，使用说明如下：

1.修改前端app.js文件里的 hostUrl appId appKey ceshiUrl 四个参数为你的小程序实际参数

2.修改前端utils/config.js文件里面的 var host = "为你的小程序网址"

3.修改前端utils/config.js文件里面的 baiduAk: '为你申请到的附近你本地的AK秘钥'

4.最后在微信小程序设置里面把https://api.map.baidu.com加入到你的 request 合法域名 socket 合法域名 uploadFile 合法域名 downloadFile 合法域名 否则无法跟你的AK互通地理定位信息



数据库为wxmini.sql，建议用Navicat MySQL导入到您的数据库，里面少量冗余数据表设计，主要涉及资讯、产品点评和商场等非核心功能或高级功能点，建议初级读者可以先忽略这些表，
重点掌握书中提及的数据表即可，以后熟练掌握了之后可以再结合这些冗余数据表加功能。



后台地址：https://www.xxx.com/index.php/Admin
用户名是admin，密码是123456 