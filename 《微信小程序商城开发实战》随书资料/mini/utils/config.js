
// 数据请求地址，修改为你的小程序网址
var host = "mini.laohuzx.com/index.php"

var config = {

  // 下面的地址配合云端 Server 工作
  host: `https://${host}/`, 

  // 数据请求接口地址
  requestUrl: `https://${host}/Huod/`,

  // 百度AK填写，用于获取地理位置 根据实际地区申请获取自己本地区的AK秘钥
  baiduAk: '为你申请到的附近你本地的AK秘钥'
  
};

module.exports = config