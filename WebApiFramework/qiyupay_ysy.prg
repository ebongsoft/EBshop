*-- 云收银H5支付
*-- 回发的Url 不能有? 
*?state=1&orderNum=006&txamt=000000000001&attach=&goodsInfo=&errDetail=validate%20signature%20error&outOrderNum=&transTime=2019-05-30%2021:29:03
clear
xx=Createobject("QiyuPay_YSY")
xx.backUrl="http://qiyu.free.idcfengye.com/ctl_notice_ht.fsp"  &&支付回调 
xx.frontUrl="http://qiyu.free.idcfengye.com/ctl_notice.fsp"  &&支付完成跳转

*-- 订单号,商品名,金额1=1分,100=1元,商户号,商户KE

lnOrder=TTOC(DATETIME(),1)
*?xx.YSY_H5Pay(lnOrder,"测试",1,"509394279960001","cbc0366cddb722ed9e733a8a1f361c1e")  &&仙泉
?xx.YSY_H5Pay(lnOrder,"测试",1,"509595572980001","56fc7ecf68862a976317417bcc35f575")  &&蒂拉

Define Class QiyuPay_YSY As Session

    backUrl=""  &&接收支付是否成功的URL 
    frontUrl=""  &&前台跳转支付是否成功的URL 
              
	Function YSY_Send(lojs,ckey)
		Local lcxml,lc签名,lc接口类型,lojson,lcErMsg
		Local lojson As foxJson, lcStatus, lcTrade_state, lcResult_code
		result= 1
		lojson =Createobject("foxJson")

		If Vartype(lojs) <>"O"
			lcErMsg = '参数的类型不匹配'
		Endif
		If Empty( lcErMsg) And Empty(ckey)
			lcErMsg = '参数Key不能为空'
		Endif
        url=""
		If Empty( lcErMsg)
			lc签名  = This.YSY_Sign(lojs,ckey )
			lojs.Append("sign",lc签名)
			lcxml =lojs.Tostring()        
            lcxml=STRCONV(lcxml,13)
            
            url="https://showmoney.cn/scanpay/unified?data="+lcxml
            _CLIPTEXT=URL
         ENDIF    
         RETURN url       
	Endfunc

	Function YSY_H5Pay(lc订单号,lc商品名称,ln金额,lc商户号,lcKey)

		Local lojs As foxJson ,lcNonce_str,lcErMsg, lojson As foxJson
		lc订单号	=Alltrim(lc订单号)
		lc商户号  	=Alltrim(lc商户号)
		lcKey 		= Alltrim(lcKey)

		If Empty(lc订单号)
			lcErMsg = '订单号不能为空'
		Endif
		If Empty(lcErMsg ) And  Empty(ln金额)
			lcErMsg = '金额必须大于等于1,以分为单位'
		Endif

		If Empty(lcErMsg ) And  Empty(lc商户号)
			lcErMsg = '商户号不能为空'
		Endif
		If Empty(lcErMsg ) And  Empty(lcKey)
			lcErMsg = 'key不能为空'
		Endif
		lojson =Createobject("foxJson")
		If Empty(lcErMsg)
			lcNonce_str = GetGUID(1)
			lojs=Createobject("foxJson")
			lojs.Append("version","2.3.5")
			lojs.Append("signType","SHA256")
			lojs.Append("charset","utf-8")
			lojs.Append("orderNum",lc订单号)
			lojs.Append("busicd","WPAY")
			lojs.Append("chcd","WXP")
			lojs.Append("mchntid",lc商户号)  
			lojs.Append("storied","")
			lojs.Append("terminalid","00000001")
			lojs.Append("operatorid","")
			cJe=PADL(INT(ln金额),12,"0")
			lojs.Append("txamt",cJe)
			lojs.Append("goodsList","")
			lojs.Append("outOrderNum","")
			lojs.Append("subject","")
			lojs.Append("attach","")
			lojs.Append("backUrl",this.backUrl)
			lojs.Append("frontUrl",this.frontUrl)
			lojs.Append("paylimit","")
			*lojs.Append("timeStart",TTOC(DATETIME(),1))
			*lojs.Append("timeExpire",TTOC(DATETIME()+60,1))
			lojs.Append("undiscountAmt","")
			lojs.Append("goodstag","")								
			
			lcjson= This.YSY_Send(lojs,lcKey )  &&Post 提交数据支付
		Else

			lojson.Append("result",1 )
			lojson.Append("err_msg", lcErMsg)
			lcjson  = lojson.tostring()
		Endif
		Return lcjson

	Endfunc

	**生成签名sign
	Function YSY_Sign(lojs,ckey)
		lcStr =""
		Dimension laString(lojs.Count,2)
		Local lnfor
		For lnjsn = 1 To lojs.Count
			laString(lnjsn,1) =lojs.Item(lnjsn).Key
			laString(lnjsn,2) =lojs.Item(lnjsn).Value
		Endfor
		=Asort(laString)  &&排序
		For lnfor = 1 To lojs.Count
		*?laString(lnfor,1),Alltrim(Transform(laString(lnfor,2)))
			If  !Empty(Alltrim(Transform(laString(lnfor,2))))   &&排序值为空的内容 Not Inlist(laString(lnfor,1),"sign") And 
				lcStr = lcStr +"&" + laString(lnfor,1)+ "=" + Alltrim(Transform(laString(lnfor,2)))
			Endif
		Endfor
		lcStr =Substr(lcStr,2) +Alltrim(Transform(ckey))  &&直接加KEY
		*?lcstr
		*_cliptext=lcSTR
		SET LIBRARY TO vfpencryption71 ADDITIVE 
		lcMd5 =hash(Strconv(lcStr,9 ),2)
		lcMd5 =STRCONV(lcMd5 ,15)   &&转十六进制
		lcMd5 =LOWER(lcMD5)
		RELEASE LIBRARY vfpencryption71 		
		Return lcMd5
	Endfunc

Enddefine