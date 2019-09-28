<?php
namespace Api\Controller;
use Think\Controller;

/**
 * 子页广告接口
 *
 * 子页广告信息API
 * Class ZhutiController
 * @package Api\Controller
 * @author  mustang <dev@xinzhenkj.com>
 */
class ZhutiController extends PublicController {

    /**
     * 首页广告数据接口
     */
    public function index(){

		$topiclist = M('zhuti')->where('1=1')->field('id,name,photo,action,subtitle,price_info')->limit(100)->select();
        foreach ($topiclist as $k => $v) {
            $topiclist[$k]['photo'] = __DATAURL__.$v['photo'];
			$topiclist[$k]['action'] =$v['action'];
			$topiclist[$k]['name'] =$v['name'];
			$topiclist[$k]['subtitle'] =$v['subtitle'];
			$topiclist[$k]['price_info'] =$v['price_info'];
        }
    	echo json_encode(array('topiclist'=>$topiclist));
    	exit();
    }
	
 }	
	
	
	
?>