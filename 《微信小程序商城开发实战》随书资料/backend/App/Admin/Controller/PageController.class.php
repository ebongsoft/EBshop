<?php
namespace Admin\Controller;
use Think\Controller;

/**
 * 页面控制器
 *
 *
 * Class PageController
 * @package Admin\Controller
 * @author  mustang <dev@xinzhenkj.com>
 */
class PageController extends PublicController{
    /**
     * 管理主页显示
     */
	public function adminindex(){	
		$this->display();
	}

    /**
     * 店铺主页显示
     */
	public function shopindex(){	
		$this->display();
	}		
}