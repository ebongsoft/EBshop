<?php

class WxPayConfig
{
    const APPID = 'wx6xxxxxxce6';//微信小程序ID
    const MCHID = '14xxxxxx62';//微信小程序支付商户号
    const KEY = '159xxxxxxxxxxx5966';//微信小程序支付密码
    const APPSECRET = 'f5cfxxxxxxxxxxxxx15dfec';//微信小程序秘钥
    const NOTIFY_URL = 'https://mini.laohuzx.com/index.php/Api/Wxpay/notify';
    const SSLCERT_PATH = '../cert/apiclient_cert.pem';
    const SSLKEY_PATH = '../cert/apiclient_key.pem';
    const CURL_PROXY_HOST = "0.0.0.0";
    const CURL_PROXY_PORT = 0;
    const REPORT_LEVENL = 1;
}
