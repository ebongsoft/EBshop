*-- ������H5֧��
*-- �ط���Url ������? 
*?state=1&orderNum=006&txamt=000000000001&attach=&goodsInfo=&errDetail=validate%20signature%20error&outOrderNum=&transTime=2019-05-30%2021:29:03
clear
xx=Createobject("QiyuPay_YSY")
xx.backUrl="http://qiyu.free.idcfengye.com/ctl_notice_ht.fsp"  &&֧���ص� 
xx.frontUrl="http://qiyu.free.idcfengye.com/ctl_notice.fsp"  &&֧�������ת

*-- ������,��Ʒ��,���1=1��,100=1Ԫ,�̻���,�̻�KE

lnOrder=TTOC(DATETIME(),1)
*?xx.YSY_H5Pay(lnOrder,"����",1,"509394279960001","cbc0366cddb722ed9e733a8a1f361c1e")  &&��Ȫ
?xx.YSY_H5Pay(lnOrder,"����",1,"509595572980001","56fc7ecf68862a976317417bcc35f575")  &&����

Define Class QiyuPay_YSY As Session

    backUrl=""  &&����֧���Ƿ�ɹ���URL 
    frontUrl=""  &&ǰ̨��ת֧���Ƿ�ɹ���URL 
              
	Function YSY_Send(lojs,ckey)
		Local lcxml,lcǩ��,lc�ӿ�����,lojson,lcErMsg
		Local lojson As foxJson, lcStatus, lcTrade_state, lcResult_code
		result= 1
		lojson =Createobject("foxJson")

		If Vartype(lojs) <>"O"
			lcErMsg = '���������Ͳ�ƥ��'
		Endif
		If Empty( lcErMsg) And Empty(ckey)
			lcErMsg = '����Key����Ϊ��'
		Endif
        url=""
		If Empty( lcErMsg)
			lcǩ��  = This.YSY_Sign(lojs,ckey )
			lojs.Append("sign",lcǩ��)
			lcxml =lojs.Tostring()        
            lcxml=STRCONV(lcxml,13)
            
            url="https://showmoney.cn/scanpay/unified?data="+lcxml
            _CLIPTEXT=URL
         ENDIF    
         RETURN url       
	Endfunc

	Function YSY_H5Pay(lc������,lc��Ʒ����,ln���,lc�̻���,lcKey)

		Local lojs As foxJson ,lcNonce_str,lcErMsg, lojson As foxJson
		lc������	=Alltrim(lc������)
		lc�̻���  	=Alltrim(lc�̻���)
		lcKey 		= Alltrim(lcKey)

		If Empty(lc������)
			lcErMsg = '�����Ų���Ϊ��'
		Endif
		If Empty(lcErMsg ) And  Empty(ln���)
			lcErMsg = '��������ڵ���1,�Է�Ϊ��λ'
		Endif

		If Empty(lcErMsg ) And  Empty(lc�̻���)
			lcErMsg = '�̻��Ų���Ϊ��'
		Endif
		If Empty(lcErMsg ) And  Empty(lcKey)
			lcErMsg = 'key����Ϊ��'
		Endif
		lojson =Createobject("foxJson")
		If Empty(lcErMsg)
			lcNonce_str = GetGUID(1)
			lojs=Createobject("foxJson")
			lojs.Append("version","2.3.5")
			lojs.Append("signType","SHA256")
			lojs.Append("charset","utf-8")
			lojs.Append("orderNum",lc������)
			lojs.Append("busicd","WPAY")
			lojs.Append("chcd","WXP")
			lojs.Append("mchntid",lc�̻���)  
			lojs.Append("storied","")
			lojs.Append("terminalid","00000001")
			lojs.Append("operatorid","")
			cJe=PADL(INT(ln���),12,"0")
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
			
			lcjson= This.YSY_Send(lojs,lcKey )  &&Post �ύ����֧��
		Else

			lojson.Append("result",1 )
			lojson.Append("err_msg", lcErMsg)
			lcjson  = lojson.tostring()
		Endif
		Return lcjson

	Endfunc

	**����ǩ��sign
	Function YSY_Sign(lojs,ckey)
		lcStr =""
		Dimension laString(lojs.Count,2)
		Local lnfor
		For lnjsn = 1 To lojs.Count
			laString(lnjsn,1) =lojs.Item(lnjsn).Key
			laString(lnjsn,2) =lojs.Item(lnjsn).Value
		Endfor
		=Asort(laString)  &&����
		For lnfor = 1 To lojs.Count
		*?laString(lnfor,1),Alltrim(Transform(laString(lnfor,2)))
			If  !Empty(Alltrim(Transform(laString(lnfor,2))))   &&����ֵΪ�յ����� Not Inlist(laString(lnfor,1),"sign") And 
				lcStr = lcStr +"&" + laString(lnfor,1)+ "=" + Alltrim(Transform(laString(lnfor,2)))
			Endif
		Endfor
		lcStr =Substr(lcStr,2) +Alltrim(Transform(ckey))  &&ֱ�Ӽ�KEY
		*?lcstr
		*_cliptext=lcSTR
		SET LIBRARY TO vfpencryption71 ADDITIVE 
		lcMd5 =hash(Strconv(lcStr,9 ),2)
		lcMd5 =STRCONV(lcMd5 ,15)   &&תʮ������
		lcMd5 =LOWER(lcMD5)
		RELEASE LIBRARY vfpencryption71 		
		Return lcMd5
	Endfunc

Enddefine