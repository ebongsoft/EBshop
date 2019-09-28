<?php
namespace Api\Controller;
use Think\Controller;

/**
 * 产品分类接口控制器
 *
 * 处理产品分类API
 * Class CategoryController
 */
class CategoryController extends PublicController {

    /**
     * 产品分类
     */
    public function index(){
    	$list = M('category')->where('tid=1')->field('id,tid,name,concent,bz_1,bz_2')->select();
        foreach ($list as $k => $v) {
            $list[$k]['bz_2'] = __DATAURL__.$v['bz_2'];
        }
        $catList = M('category')->where('tid='.intval($list[0]['id']))->field('id,name,bz_1')->select();
        foreach ($catList as $k => $v) {
            $catList[$k]['bz_1'] = __DATAURL__.$v['bz_1'];
        }

    	$product = M('product');
		$goodsCount = $product->count();
		$this->assign('goodsCount', $goodsCount);
		echo json_encode(array('status'=>1,'list'=>$list,'catList'=>$catList,'goodsCount'=>$goodsCount));
        exit();
    }


    /**
     * 获取产品分类信息
     */
    public function getcat(){
        $catid = intval($_REQUEST['cat_id']);
        if (!$catid) {
            echo json_encode(array('status'=>0,'err'=>'没有找到产品数据.'));
            exit();
        }

        $catList = M('category')->where('tid='.intval($catid))->field('id,name,bz_1')->select();
        foreach ($catList as $k => $v) {
            $catList[$k]['bz_1'] = __DATAURL__.$v['bz_1'];
        }
        echo json_encode(array('status'=>1,'catList'=>$catList));
        exit();
    }

}