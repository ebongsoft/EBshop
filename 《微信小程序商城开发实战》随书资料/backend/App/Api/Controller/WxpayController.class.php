<?php
namespace Api\Controller;
use Think\Controller;

/**
 * 微信支付接口
 *
 * 调起微信支付功能
 * Class WxpayController
 */
class WxpayController extends Controller{

    public function _initialize(){
    	//php 判断http还是https
    	$this->http_type = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')) ? 'https://' : 'http://';
		vendor('WeiXinpay.wxpay');
	}

    /**
     * 微信支付 接口
     */
	public function wxpay(){

        //记录日志：要写入文件的文件名（可以是任意文件名），如果文件不存在，将会创建一个.log.txt位置在项目的根目录下。
        $file  = 'log.txt';
        $content = "微信支付请求参数：\n";
        $content .= "请求参数内容".json_encode($_REQUEST)."\n";
        // 这个函数支持版本(PHP 5)
        if($f  = file_put_contents($file, $content,FILE_APPEND)){
            //echo "成功。<br />";
        }

		$pay_sn = trim($_REQUEST['order_sn']);
		if (!$pay_sn) {
			echo json_encode(array('status'=>0,'err'=>'支付信息错误！'));
			exit();
		}

		$order_info = M('order')->where('order_sn="'.$pay_sn.'"')->find();
		if (!$order_info) {
			echo json_encode(array('status'=>0,'err'=>'没有找到支付订单！'));
			exit();
		}

		if (intval($order_info['status'])!=10) {
			echo json_encode(array('status'=>0,'err'=>'订单状态异常！'));
			exit();
		}

		//①、获取用户openid
		$tools = new \JsApiPay();
		$openId = M('user')->where('id='.intval($order_info['uid']))->getField('openid');
		if (!$openId) {
			echo json_encode(array('status'=>0,'err'=>'用户状态异常！'));
			exit();
		}
		
		//②、统一下单
		$input = new \WxPayUnifiedOrder();
		$input->SetBody("信真小铺商品购买_".trim($order_info['order_sn']));
		$input->SetAttach("信真小铺商品购买_".trim($order_info['order_sn']));
		$input->SetOut_trade_no($pay_sn);
		$input->SetTotal_fee(floatval($order_info['amount'])*100);
		$input->SetTime_start(date("YmdHis"));
		$input->SetTime_expire(date("YmdHis", time() + 3600));
		$input->SetGoods_tag("信真小铺商品购买_".trim($order_info['order_sn']));
		$input->SetNotify_url('https://mini.laohuzx.com/index.php/Api/Wxpay/notify');
		$input->SetTrade_type("JSAPI");
		$input->SetOpenid($openId);
		$order = \WxPayApi::unifiedOrder($input);

		$arr = array();
		$arr['appId'] = $order['appid'];
		$arr['nonceStr'] = $order['nonce_str'];
		$arr['package'] = "prepay_id=".$order['prepay_id'];
		$arr['signType'] = "MD5";
		$arr['timeStamp'] = (string)time();
		$str = $this->ToUrlParams($arr);
		$jmstr = $str."&key=".\WxPayConfig::KEY;
		$arr['paySign'] = strtoupper(MD5($jmstr));
		echo json_encode(array('status'=>1,'arr'=>$arr));
		exit();

	}

    /**
     * 支付回调
     */
	public function notify(){

		$res_xml = file_get_contents("php://input");
		libxml_disable_entity_loader(true);
		$ret = json_decode(json_encode(simplexml_load_string($res_xml,'simpleXMLElement',LIBXML_NOCDATA)),true);

		$path = "./Data/log/";
		if (!is_dir($path)){
			mkdir($path,0777);  // 创建文件夹test,并给777的权限（所有权限）
		}
		$content = date("Y-m-d H:i:s").'=>'.json_encode($ret);  // 写入的内容
		$file = $path."weixin_".date("Ymd").".log";    // 写入的文件
		file_put_contents($file,$content,FILE_APPEND);  // 最简单的快速的以追加的方式写入写入方法，

		$data = array();
		$data['order_sn'] = $ret['out_trade_no'];
		$data['pay_type'] = 'weixin';
		$data['trade_no'] = $ret['transaction_id'];
		$data['total_fee'] = $ret['total_fee'];
		$result = $this->orderhandle($data);
		if (is_array($result)) {
			$xml = "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg>";
			$xml.="</xml>";
			echo $xml;
		}else{
			$contents = 'error => '.json_encode($result);  // 写入的内容
			$files = $path."error_".date("Ymd").".log";    // 写入的文件
			file_put_contents($files,$contents,FILE_APPEND);  // 最简单的快速的以追加的方式写入写入方法，
			echo 'fail';
		}
	}

    /**
	 * 订单处理
     * @param $data
     * @return array|string
     */
	public function orderhandle($data){
		$order_sn = trim($data['order_sn']);
		$pay_type = trim($data['pay_type']);
		$trade_no = trim($data['trade_no']);
		$total_fee = floatval($data['total_fee']);
		$check_info = M('order')->where('order_sn="'.$order_sn.'"')->find();
		if (!$check_info) {
			return "订单信息错误...";
		}

		if ($check_info['status']<10 || $check_info['back']>'0') {
			return "订单异常...";
		}

		if ($check_info['status']>10) {
			return array('status'=>1,'data'=>$data);
		}

		$up = array();
		$up['type'] = $pay_type;
		$up['price_h'] = sprintf("%.2f",floatval($total_fee/100));
		$up['status'] = 20;
		$up['trade_no'] = $trade_no;
		$res = M('order')->where('order_sn="'.$order_sn.'"')->save($up);
		if ($res) {
			//处理优惠券
			if (intval($check_info['vid'])) {
				$vou_info = M('user_voucher')->where('uid='.intval($check_info['uid']).' AND vid='.intval($check_info['vid']))->find();
				if (intval($vou_info['status'])==1) {
					M('user_voucher')->where('id='.intval($vou_info['id']))->save(array('status'=>2));
				}
			}
			return array('status'=>1,'data'=>$data);
		}else{
			return '订单处理失败...';
		}
	}

    /**
	 * 构建字符串
     * @param $urlObj
     * @return string
     */
	private function ToUrlParams($urlObj)
	{
		$buff = "";
		foreach ($urlObj as $k => $v)
		{
			if($k != "sign"){
				$buff .= $k . "=" . $v . "&";
			}
		}
		
		$buff = trim($buff, "&");
		return $buff;
	}
}
?>
