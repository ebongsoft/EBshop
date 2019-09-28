<?php
namespace Api\Controller;
use Think\Controller;

/**
 * 首页接口
 *
 * 处理首页信息API
 * Class IndexController
 */
class IndexController extends PublicController {

    /**
     * 首页信息接口
     */
    public function index(){

        //顶部轮播图广告
    	$ggtop=M('guanggao')->order('sort desc,id asc')->field('id,name,photo,action')->limit(10)->select();
		foreach ($ggtop as $k => $v) {
			$ggtop[$k]['photo']=__DATAURL__.$v['photo'];
			$ggtop[$k]['name']=urlencode($v['name']);
			$ggtop[$k]['action']=$v['action'];
		}

        //产品分类
        $category = M('category')->where('tid=1')->field('id,name,bz_1')->limit(8)->select();
        foreach ($category as $k => $v) {
            $category[$k]['bz_1'] = __DATAURL__.$v['bz_1'];
        }

        $product = M('product');
		$goodsCount = $product->count();
		$this->assign('goodsCount', $goodsCount);
        //商品列表，目前冗余
    	$pro_list = M('product')->where('del=0 AND pro_type=1 AND is_down=0 AND type=1')->order('sort desc,id desc')->field('id,name,intro,photo_x,price_yh,price,shiyong')->limit(8)->select();
    	foreach ($pro_list as $k => $v) {
    		$pro_list[$k]['photo_x'] = __DATAURL__.$v['photo_x'];
    	}

		//新品首发
		$newGoods = M('product')->where('del=0 AND pro_type=1 AND is_down=0 AND type=1')->order('sort desc,id desc')->field('id,name,intro,photo_x,price_yh,price,shiyong')->limit(8)->select();
    	foreach ($newGoods as $k => $v) {
    		$newGoods[$k]['photo_x'] = __DATAURL__.$v['photo_x'];
    	}

    	echo json_encode(array('ggtop'=>$ggtop,'prolist'=>$pro_list,'newGoods'=>$newGoods,'category'=>$category,'goodsCount'=>$goodsCount));
    	exit();
    }

    /**
     * 产品列表
     */
    public function getlist(){
        $page = intval($_REQUEST['page']);
        $limit = intval($page*8)-8;

        $pro_list = M('product')->where('del=0 AND pro_type=1 AND is_down=0 AND type=1')->order('sort desc,id desc')->field('id,name,photo_x,price_yh,shiyong')->limit($limit.',8')->select();
        foreach ($pro_list as $k => $v) {
            $pro_list[$k]['photo_x'] = __DATAURL__.$v['photo_x'];
        }

        echo json_encode(array('prolist'=>$pro_list));
        exit();
    }


}