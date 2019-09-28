var app = getApp();
Page({
    data: {
        typeTree: {}, // 数据缓存
        currType: 0 ,
        // 当前类型
        "types": [],
        typeTree: [],
	    goodsCount: []
    },
        
    onLoad: function (option){
        var that = this;
        wx.request({
            url: app.d.ceshiUrl + '/Api/Category/index',
            method:'post',
            data: {},
            header: {
                'Content-Type':  'application/x-www-form-urlencoded'
            },
            success: function (res) {
                var status = res.data.status;
                if(status==1) { 
                    var list = res.data.list;
                    var catList = res.data.catList;
		            var goodsCount = res.data.goodsCount;
                    that.setData({
                        types:list,
                        typeTree:catList,
			            goodsCount:goodsCount,
                    });
                } else {
                    wx.showToast({
                        title:res.data.err,
                        duration:2000,
                    });
                }
     that.setData({
            currType: 2
        });    
      console.log(list)

            },
            error:function(e){
                wx.showToast({
                    title:'网络异常！',
                    duration:2000,
                });
            },

        });
    },
    tapType: function (e){
        var that = this;
        const currType = e.currentTarget.dataset.typeId;

        that.setData({
            currType: currType
        });
        console.log(currType);
        wx.request({
            url: app.d.ceshiUrl + '/Api/Category/getcat',
            method:'post',
            data: {cat_id:currType},
            header: {
                'Content-Type':  'application/x-www-form-urlencoded'
            },
            success: function (res) {
                var status = res.data.status;
                if(status==1) { 
                    var catList = res.data.catList;
                    that.setData({
                        typeTree:catList,
                    });
                } else {
                    wx.showToast({
                        title:res.data.err,
                        duration:2000,
                    });
                }
            },
            error:function(e){
                wx.showToast({
                    title:'网络异常！',
                    duration:2000,
                });
            }
        });
    },
    // 加载品牌、二级类目数据
    getTypeTree (currType) {
        const me = this, _data = me.data;
        if(!_data.typeTree[currType]){
            request({
                url: ApiList.goodsTypeTree,
                data: {typeId: +currType},
                success: function (res) {
                    _data.typeTree[currType] = res.data.data;
                    me.setData({
                        typeTree: _data.typeTree
                    });
                }
            });
        }
  },
      //右上角分享按钮
    onShareAppMessage: function () {
    return {
      title: '产品分类',
	  desc: '信真小铺微信小程序商城',
      path: '/pages/category/index',
	  data:{data}
    }
 }
})