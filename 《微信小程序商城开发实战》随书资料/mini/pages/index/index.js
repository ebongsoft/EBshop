//获取小程序实例
var app = getApp();

Page({
  data: {
    imgUrls: [],
    indicatorDots: true,
    autoplay: true,
    interval: 5000,
    duration: 1000,
    circular: true,
	goodsCount: [],
    //productData: [],
    proCat:[],
    page: 2,
    index: 2,
    // 滑动
    imgUrl: [],
    kbs:[],
    lastcat:[],
    category:[],
	newGoods: [],
    floorGoods: []
  },
//跳转商品列表页   
listdetail:function(e){
    console.log(e.currentTarget.dataset.title)
    wx.navigateTo({
      url: '../listdetail/listdetail?title='+e.currentTarget.dataset.title,
      success: function(res){
        // success
      },
      fail: function() {
        // fail
      },
      complete: function() {
        // complete
      }
    })
  },

//点击加载更多
getMore:function(e){
  var that = this;
  var page = that.data.page;
  wx.request({
      url: app.d.ceshiUrl + '/Api/Index/getlist',
      method:'post',
      data: {page:page},
      header: {
        'Content-Type':  'application/x-www-form-urlencoded'
      },
      success: function (res) {  
        var prolist = res.data.prolist;
        if(prolist==''){
          wx.showToast({
            title: '没有更多数据！',
            duration: 2000
          });
          return false;
        }
        //that.initProductData(data);
        //that.setData({
        //  page: page+1,
        //  productData:that.data.productData.concat(prolist)
        //});
        //endInitData
      },
      fail:function(e){
        wx.showToast({
          title: '网络异常！',
          duration: 2000
        });
      }
    })
},

  changeIndicatorDots: function (e) {
    this.setData({
      indicatorDots: !this.data.indicatorDots
    })
  },
  changeAutoplay: function (e) {
    this.setData({
      autoplay: !this.data.autoplay
    })
  },
  intervalChange: function (e) {
    this.setData({
      interval: e.detail.value
    })
  },
  durationChange: function (e) {
    this.setData({
      duration: e.detail.value
    })
  },

  onLoad: function (options) {
    var that = this;
    wx.request({
      url: app.d.ceshiUrl + '/Api/Index/index',
      method:'post',
      data: {},
      header: {
        'Content-Type':  'application/x-www-form-urlencoded'
      },
      success: function (res) {  
        //顶部轮播图广告
        var ggtop = res.data.ggtop;
        var prolist = res.data.prolist;
        //商品数量
		    var goodsCount = res.data.goodsCount;
        //商品分类
        var category = res.data.category;
        //新品
		    var newGoods = res.data.newGoods;
        that.setData({
          imgUrls:ggtop,
          //productData:prolist,
		  goodsCount: goodsCount,
          category: category,
		  newGoods: res.data.newGoods,
        });
      },
      fail:function(e){
        wx.showToast({
          title: '网络异常！',
          duration: 2000
        });
      },
    })

  },
  onShareAppMessage: function () {
    return {
      title: '首页',
      desc: '信真小铺-信守真品的自营电商小程序',
      path: '/pages/index/index',
      success: function(res) {
        // 分享成功
      },
      fail: function(res) {
        // 分享失败
      }
    }
  }
});