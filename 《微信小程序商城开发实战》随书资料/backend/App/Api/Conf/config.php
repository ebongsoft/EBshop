<?php

header("Content-Type:text/html; charset=utf-8");
error_reporting(0);

define('SELF_ROOT','https://mini.你的小程序服务端网址.com/');

$urkn= SELF_ROOT."Data/app/";
define('APP_URL',$urkn);

return array(

    'key'         =>   15222,
    'URL_MODEL'   =>0,
    'app_name'   =>'你的小程序签名',
    'DB_FIELDS_CACHE'       =>true,
    'base'					=>$urkn.'62/3057c1502ae5a4d514baec129f72948c266e/',
    'TMPL_CACHE_ON' => false,
    'HTML_CACHE_ON' => false,
    'LOG_RECORD'            =>  false,
    'LOG_TYPE'              =>  'File',
    'LOG_LEVEL'             =>  'EMERG,ALERT,CRIT,ERR',
    'LOG_EXCEPTION_RECORD'  =>  false,
    'LOAD_EXT_CONFIG' => "functions",

    'TMPL_PARSE_STRING'=>array(
        '__DATA__'=>__ROOT__.'/Data'
    ),
    'TMPL_ACTION_ERROR'     =>  'Public/error',
    'TMPL_ACTION_SUCCESS'   =>  'Public/success',

    'weixin'=>array(
        'appid' =>'wx6782xxxxxxf5ce6',//微信小程序appid
        'secret'=>'f5cf0cac6xxxxxxxxxxx8b1a215dfec', //微信小程序secret
        'mchid' => '14xxxxxx162',//小程序支付商户号
        'key' => '1590xxxxxxxxxxxxxxx1175966',//小程序支付KEY
        'notify_url'=>'https://mini.laohuzx.com/index.php/Api/Wxpay/notify',
    ),
);
?>