var app = getApp();
Page({
 data: {
   name:'',
   tel:'',
   message:''
},
onLoad:function(options){  
    // 页面初始化 options为页面跳转所带来的参数  
  },  
  onReady:function(){  
    // 页面渲染完成  
  },  
  onShow:function(){  
    // 页面显示  
  },  
  onHide:function(){  
    // 页面隐藏  
  },  
  onUnload:function(){  
    // 页面关闭  
  },  
// 表单
 reg: function (e) {
  console.log(e.detail.value);
  //存储数据
  var that = this;
  var name = e.detail.value.name;
  var tel = e.detail.value.tel;
  var message = e.detail.value.message;
  if (!name || !tel || !message) {
    wx.showToast({
      title: "请先完善反馈信息!",
      duration: 2000
    });
    return false;
  }
  that.setData({
     tel: e.detail.tel,
	 name: e.detail.name,
	 message: e.detail.message,
    });
  //创建信息
  wx.request({
    url: app.d.ceshiUrl + '/Api/User/feedback',
    method: 'post',
    data: {
      uid: app.d.userId,
      name: e.detail.value.name,
      tel: e.detail.value.tel,
      message: e.detail.value.message,
    },
    header: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    success: function (res) {
      var data = res.data;
      if (data.status == 1) {
       wx.showToast({
                title: '反馈成功！',
                duration: 2000
              });
      } else {
        wx.showToast({
          title: res.data.err,
          duration: 2300
        });
      }
    },
    fail: function (e) {
      wx.hideToast();
      wx.showToast({
        title: '网络异常！err:createProductOrder',
        duration: 2000
      });
    }
  });
},

})