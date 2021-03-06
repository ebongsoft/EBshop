* CreateMSSQLTables.PRG

SET TALK OFF
CLEAR
CLOSE ALL
SET STRICTDATE TO 0
SET SAFETY OFF
SET EXCLUSIVE ON
SET CONFIRM ON

*!*	连接SQL数据库---------------------------------------------------------------------------------
ConnStr = [Driver={SQL Server};Server=192.168.2.8;UID=sa;PWD=3b7d29akfq93lgs8;Database=EbShopdb;]
Handle = SQLSTRINGCONNECT( ConnStr )
IF Handle < 1
   MESSAGEBOX( "无法连接到数据库" + CHR(13) + ConnStr, 16 )
   RETURN
ENDIF

     
*!* 创建MSSQL表
TEXT TO cmd NOSHOW TEXTMERGE


	/* 用户表 */
	CREATE TABLE [user] ( 
		id int identity(1,1) not null primary key,
		name varchar(50),
		pwd varchar(50),
		addtime int,
		jifen decimal(11,0),
		photo varchar(255),
		tel char(15),
		qq_id varchar(20),
		email varchar(50),
		sex int,del int,
		openid varchar(50),
		source varchar(50) 
	)
    
	/* 产品表 */
	CREATE TABLE [product] ( 
		id int identity(1,1) not null primary key,
		shop_id int,
		brand_id int,
		name varchar(50),
		intro varchar(100),
		pro_number varchar(100),
		price_jf int,
		price decimal(8,2) null default '0.00',
		price_yh decimal(8,2) null DEFAULT '0.00',
		photo_x varchar(100) null,
		photo_d varchar(100) null,
		photo_string varchar(50) null,
		content varchar(250) null,
		addtime datetime null,
		updatetime datetime null,
		sart int,
		renqi int,
		shiyong int,
		num int,
		type int default '0',
		del int default '0',
		del_time datetime null,
		pro_buff varchar(250) null,
		cid int,
		company char(10) null,
		is_show int default '0',
		is_down int default '0',
		is_hot int default '0',
		is_sale int default '0',
		start_time datetime null,
		end_time datetime null,
		pro_type int default '0'
	)
    
	/* 收货地址表 */
	CREATE TABLE [address] (
		id int identity(1,1) not null primary key,
		name varchar(10) null,
		tel char(15) null,
		sheng int,
		city int,
		quyu int,
		address varchar(10) null,
		address_xq varchar(255) null,
		code int,
		uid int,
		is_default int default '0'
	)

	/* 省市区地址联动表 */
	CREATE TABLE [china_city] (
		id int identity(1,1) not null primary key,
		tid int,
		name varchar(60) null,
		code varchar(60) null,
		head varchar(2) null,
		type int default '0'
	)

	/* 广告信息表 */
	CREATE TABLE [guanggao] (
		id int identity(1,1) not null primary key,
		name varchar(255) null,
		photo varchar(100) null,
		addtime int default '0',
		sort int default '0',
		type int default '0',
		action varchar(255) null,
		position int default '1'
	)

	/* 优惠卷表 */
	CREATE TABLE [voucher] (
		id int identity(1,1) not null primary key,
		shop_id int default '0',
		title varchar(100) null,
		full_money decimal(9,2) null default '0.00',
		anount decimal(8,2) null default '0.00',
		start_time datetime null,
		end_time datetime null,
		point int default '0',
		count int default '1',
		receive_num int default '0',
		addtime datetime null,
		type int default '1',
		tel int default '0', 
		proid int
	)

	/* 优惠券领券记录 */
	CREATE TABLE [user_voucher] (
		id int identity(1,1) not null primary key,
		uid int default '0',
		vid int default '0',
		shop_id int default '0',
		full_money decimal(8,2) null default '0.00',
		amount decimal(8,2) null default '0.00',
		start_time datetime null,
		end_time datetime null,
		addtime datetime null,
		status int default '1'
	)
	 
	/* 搜索记录表 */
	CREATE TABLE [search_record] (
		id int identity(1,1) not null primary key,
		uid int default '0',
		keyword varchar(255) null,
		num int default '0',
		addtime datetime null
	)
	 
	/* 意见反馈表 */
	CREATE TABLE [fankui] (
		id int identity(1,1) not null primary key,
		uid varchar(50),
		message varchar(255),
		addtime datetime null
	)

	/* 创建商品品牌表 */
	CREATE TABLE [brand] (
		id int identity(1,1) not null primary key,
		name varchar(100),
		brandprice decimal(8,2) DEFAULT '0.00',
		photo varchar(100),
		type int DEFAULT '0',
		addtime int,
		shop_id int DEFAULT '0'
	)
	
	/*  创建商品分类表 */
	CREATE TABLE [category] (
		id int identity(1,1) not null primary key,
		tid int DEFAULT '0',
		name varchar(50),
		sort int DEFAULT '0',
		addtime int DEFAULT '0',
		concent varchar(255) DEFAULT'0',
		bz_1 varchar(100),
		bz_2 varchar(255),
		bz_3 varchar(100),
		bz_4 int,
		bz_5 varchar(100)
	)
	
	/* 创建订单表 */
	CREATE TABLE [order] (
		id int identity(1,1) not null primary key,
		order_sn varchar(20),
		pay_sn varchar(20),
		shop_id int,
		uid int DEFAULT '0',
		price decimal(9,2) DEFAULT '0.00',
		amount decimal(9,2) DEFAULT '0.00',
		addtime int DEFAULT '0',
		del int DEFAULT '0',
		pay_type varchar(10),
		price_h decimal(9,2) DEFAULT '0.00',
		status int,
		vid int DEFAULT '0',
		receiver varchar(15),
		tel char(15),
		address_xq varchar(50),
		code int,
		post int,
		remark varchar(255),
		post_remark varchar(255),
		product_num int DEFAULT '1',
		trade_no varchar(50),
		kuaidi_name varchar(10),
		kuaidi_num varchar(20),
		 back varchar(1) DEFAULT '0',
		back_remark varchar(255),
		back_addtime int,
		order_type int
	)
    
	/* 创建订单商品信息表 */
	CREATE TABLE [order_product] (
		id int identity(1,1) not null primary key,
		pid int DEFAULT '0',
		pay_sn varchar(20),
		order_id int DEFAULT '0',
		name varchar(50),
		price decimal(8,2) DEFAULT '0.00',
		photo_x varchar(100),
		pro_buff varchar(255),
		addtime int,
		num int DEFAULT '1',
		pro_guige varchar(50)     
	)            
    
	/* 创建购物车表  */
	CREATE TABLE [shopping_char] (
		id int identity(1,1) not null primary key,
		pid int DEFAULT '0',
		price decimal(9,2) DEFAULT '0.00',
		num int DEFAULT '1',
		buff varchar(255),
		addtime int,
		uid int,
		shop_id int DEFAULT '0',
		gid int DEFAULT '0',
		type int DEFAULT '2'
	)     
	 

ENDTEXT 


lr = SQLEXEC(Handle, Cmd) && 发送SQL命令
IF lr < 0 
  MESSAGEBOX("创建数据表失败",16 )
  SUSPEND  && 终止类过程的运行
ELSE 
  MESSAGEBOX("创建数据库表成功!",8)
ENDIF       

SQLDISCONNECT(0) && 断开数据库
*!*	---------------------------------------------------------------------------------------------