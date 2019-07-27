var tool = {
	validatePhone: function(phone) {
		var reg = /^1[34578]\d{9}$/
		return reg.test(tool.trim(phone));
	},
	validateIDCard: function(IDCard) {
		var isIDCard1 = /^[1-9]{1}[0-9]{14}$|^[1-9]{1}[0-9]{16}([0-9]|[xX])$/;
		if(!isIDCard1.test(IDCard)) {
			return false;
		} else {
			return true;
		}
	},
	validateContact: function(contact) { //验证电话号码，手机号码
		var reg = /(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/;
		if(reg.test(contact)) {
			return true;
		} else {
			return false;
		}
	}, 
	validateBank: function(Bank) {
		/*验证银行卡号*/
		var reg = /^([1-9]{1})(\d{14}|\d{18})$/;
		return reg.test(tool.trim(Bank));
	},
	Safetylock: function(lock) {
		/*验证安全锁*/  
		var reg = /^[0-9]{4,6}$/; 
		return reg.test(tool.trim(lock));
	},
	validatePasswrd: function(pwd) {
		/*验证密码*/ 
		var reg = /\w{6,20}/;
		return reg.test(tool.trim(pwd));
	},
	validateRePassword: function(repwd, pwd) {
		/*验证再次输入的密码*/
		if(tool.validatePasswrd(pwd)) {
			return repwd == pwd;
		} else {
			return false;
		}
	},
	isEmpty: function(str) {
		return tool.trim(str).length == 0;
	},
	trim: function trim(str) {
		return(str + "").replace(/(^\s*)|(\s*$)/, "");
	},
	throttle: function(method, delay) {
		/*函数节流简单讲就是让一个函数无法在很短的时间间隔内连续调用，
		 * 只有当上一次函数执行后过了你规定的时间间隔，才能进行下一次该函数的调用。比如为页面绑定resize事件的时候。
		 * method为事件执行的函数，delay为时间，以毫秒为单位*/
		var timer = null;
		return function() {
			clearTimeout(timer);
			var context = this,
				argus = arguments
			timer = setTimeout(function() {
				method.apply(context, argus);
			}, delay);
		}
	},
	getVerifyCodeCountDown: function(options) { //按钮倒计时，如点击按钮获取手机验证码的倒计时
		var currentFn = arguments.callee;
		return function(e) {
			e.preventDefault();
			clearInterval(timer);
			if(!(options && options.callBack)) {
				throw new Error("必须传递参数及回调函数");
			}
			var that = $(this);
			if(options.isPhone) {
				var phone = options.getPhone(),
					reg = options.phoneReg || /^0?1[3|4|5|7|8][0-9]\d{8}$/;
				if(!reg.test(phone)) {
					//如果手机号码不正确，则执行手机号码对应的回调函数
					options.phoneCallBack && options.phoneCallBack.call(that, phone);
					return;
				}
			}

			var timer = null,
				time = options.time || 60,
				unabledClass = options.unabledClass || "";
			that.off("tap");
			that.addClass(unabledClass);
			timer = setInterval(function() {
				//避免重复发送
				if(time <= 0) {
					clearInterval(timer);
					time = 60;
					that.html("重新获取").removeClass(unabledClass);
					that.on("tap", currentFn(options));
				} else {
					time--;
					that.html(time + "s后重新获取");
				}
			}, 1000);
			//执行回调函数
			options.callBack.call(that);
		}
	},
	countDown: function(ele, fn, timeOut) {
		/*时间倒计时，ele为倒计时组件最外层的元素，fn为回调函数，每隔一秒都会执行回调函数并依次传入时、分、秒、天
		 timeOut为时间到了之后该执行的回调函数*/
		var timer = null,
			dataset = ele[0].dataset,
			startDateStr = dataset.startdate || "",
			endDateStr = dataset.enddate || "";
		if(!(fn && endDateStr)) {
			return;
		}

		timer = setInterval(function() {
			var startDate = null,
				endDate = null,
				startDateTime = null,
				endDateTime = null,
				currentSecound = null, //获取当前的毫秒数
				totalSecound = 0,
				secounds = 0,
				minutes = 0,
				hours = 0,
				day = 0;

			startDateStr ? startDate = new Date(tool.formatDate(startDateStr, "/")) : startDate = new Date();
			endDate = new Date(tool.formatDate(endDateStr, "/"));
			startDateTime = startDate.getTime();
			currentSecound = startDate.getMilliseconds();
			endDateTime = endDate.getTime();

			totalSecound = (endDateTime - startDateTime - currentSecound) / 1000;

			if(endDateTime < startDateTime) {
				clearInterval(timer);
				throw new Error("结束时间不能小于起始时间！");
			}

			//倒计时时间到了
			if(totalSecound <= 0) {
				clearInterval(timer);
				if(timeOut) {
					timeOut();
				}
				return;
			}

			secounds = Math.floor(totalSecound % 60);
			minutes = Math.floor(totalSecound / 60 % 60);
			hours = Math.floor(totalSecound / 3600 % 60);
			day = Math.floor(totalSecound / 3600 / 24);

			if(secounds < 10) {
				secounds = "0" + secounds;
			}
			if(minutes < 10) {
				minutes = "0" + minutes;
			}
			if(hours < 10) {
				hours = "0" + hours;
			}

			fn(hours, minutes, secounds, day);
		}, 1000);
	},
	/*获取用户选中的商品属性*/
	getStandardChoosed: function(ele) {
		if(!ele) {
			throw new Error("必须传入元素");
		}
		var choosedValues = {}, //存储用户选择的商品属性
			$choosed = $(".choosed"),
			str = "",
			radios = ele.find(":radio");
		$("body").on("change", ele.find(":radio"), function() {
			radios.each(function() {
				if($(this).prop("checked")) { //判断单选框是否选中
					var name = $(this).prop("name"),
						value = $(this).val();
					if(value != "on") {
						//如果单选框的value属性没有值，那么获取到的就是"on"，因此将其屏蔽
						choosedValues[name] = value;
						choosedValues["_" + name + "_desc"] = $(this).parent().children("label").html();
					}
				}
			});

			str = "";
			for(var attr in choosedValues) {
				if(/_\w*_desc/.test(attr)) {
					str += choosedValues[attr] + ",";
				}
			}
			$choosed.html(str.substr(0, str.length - 1));

			/*给window对象添加一个getChoosedStandard方法，
			 * 在用户选折了商品属性后在外面可以获取的到用户选折的所有商品属性。
			 * 调用方式window.getChoosedStandard()，需做判断*/
			window.getChoosedStandard = function() {
				return choosedValues;
			}
		});
	},
	formatDate: function(str, symbol) {
		/*将2016-12-27 14:42:30字符串转成2016/12/27 14:42:30
		 str为时间字符串，symbol为连接符*/
		var strArr = [];
		str = str.replace(/-/g, symbol);
		strArr = str.split(" ");
		if(!strArr) {
			str += " 23:59:59";
		}
		return str;
	},
	/*选择图片预览*/
	imagePreview: function(ele, fn) {
		/*ele为input file元素，默认会为file元素绑定change事件。fn为回调函数，默认会传递两个值，第一个为当前文件，第二个位用户选择的所有文件*/
		if(!(ele && fn)) {
			throw new Error("必须传递file元素及回调函数");
		}
		tool.getUploadFiles(ele, function(currentFiles, choosedFiles) {
			if(currentFiles.length > 0){
				var images = [];
				for(var i = 0,len = currentFiles.length; i < len; i ++){
					//必须为图片才能进行预览
					if(/image\/|\s*/.test(currentFiles[i].type)) {
						var img = tool.fileOrBlobToObjectURL(currentFiles[i]);
						images.push(img);
						/*如果在这里调用回调函数，那么配置差的手机会报堆内存空间溢出的情况*/
						//fn.call(this, img, choosedFiles);
					}
				}
				fn.call(this, images, choosedFiles);
			}
		});
	},
	/*获取用户选择的文件*/
	getUploadFiles: function(ele, fn) {
		/*ele为input file元素，默认会为file元素绑定change事件。fn为回调函数，默认会传递两个值，第一个为当前文件，第二个位用户选择的所有文件*/
		if(!(ele && fn)) {
			throw new Error("必须传递file元素及回调函数");
		}
		var choosedFiles = {}; //存储用户选择的文件，按文件类型进行分类
		ele.on("change", function() {
			var that = this,
				files = this.files,
				length = files.length;

			if(!this.multiple) {
				//如果当前file框没有开启多选，则每次改变都清空原来所选择的文件
				choosedFiles = {};
			}
			for(var i = 0; i < length; i++) {
				//给选择的文件进行分类
				var type = files[i].type;
				if(choosedFiles[type]) {
					choosedFiles[type].push(files[i]);
				} else {
					choosedFiles[type] = [files[i]];
				}
				/*如果在这里调用回调函数，那么配置差的手机会报堆内存空间溢出的情况*/
				//fn.call(that, files[i], choosedFiles);
			}
			fn.call(that, files, choosedFiles);
		});
	},
	/*将file对象转成image，file对象必须是图片类型 */
	fileOrBlobToObjectURL: function(fileOrBlob) {
		var img = document.createElement("img");
		if(window.URL) {
			var imgSrc = window.URL.createObjectURL(fileOrBlob);
			img.src = imgSrc;
			img.addEventListener("load", function() {
				window.URL.revokeObjectURL(imgSrc);
			}, false);
		} else if(window.FileReader) {
			var reader = new FileReader();
			reader.addEventListener("load", function(e) {
				var e = e || window.event;
				img.src = e.target.result;
			}, false);
			reader.readAsDataURL(fileOrBlob);
		}
		return img;
	},
	progress: function() { /*自定义进度条*/
		var obj = new Object();
		obj.init = function(ele, percent) { //初始化单个进度条
			if((!ele) && isNaN(parseInt(percent))) {
				throw new Error("必须传递进度条元素和进度值！")
			}
			percent = Math.abs(percent) / 100;
			ele.children(".progress-inner").width(ele.width() * percent);
		}
		obj.initAll = function() { //初始化所有进度条
			$("._progress-bar-outer").each(function() {
				var that = $(this)
				obj.init(that, that.data("percent"));
			});
		}
		return obj;
	},
	openNewPage: function(id,styles,extras) {
		//页面跳转。使用方法直接在所需要跳转的地方加上 onclick="openNewPage('ticket.html')"
		mui.openWindow({
			id: id,
			url: id,
			show: {
				//aniShow: 'fade-in-left',
				duration: "200"
			},
			styles: styles,
			extras: extras,
			waiting: {
				autoShow: false
			}
		});
	},
	calculateStarWidth: function() {
		//计算等级星星等级
		$(".star-outer").each(function() {
			var outerWidth = $(this).width(),
				$starInner = $(this).children(".star-inner"),
				level = $starInner.data("level") || 0,
				percent = outerWidth / 10;

			$starInner.width(level * 2 * percent);
		});
	},
	shade: function(fn, autohide) { /*fn为关闭遮罩后的回调函数*/
		//遮罩显示与隐藏
		var obj = {},
			_shade = $("<div class='_shade'></div>"),
			autohide = autohide || true;
		obj.show = function() {
			var ele = $(_shade);
			$("body").append(ele);
			return ele;
		};
		obj.hide = function(fn) {
			$("._shade").remove();
			if(fn) { //执行回调函数
				fn.call(window);
			}
		};
		if(autohide) {
			_shade.on("tap", function() {
				$(this).remove();
				if(fn) { //执行回调函数，当点击遮罩后关闭当前遮罩，并执行回调函数
					fn.call(window);
				}
			});
		}
		return obj;
	},
	standard: function(ele) {
		if(!ele) {
			throw new Error("必须传递元素");
		}
		//商品规格弹窗口，即点击"加入购物车"后的弹出框
		var obj = {},
			shade = null;
		obj.show = function() {
			var windowHeight = $(window).height();
			shade = tool.shade(function() { //关闭遮罩后所处理业务
				ele.slideUp();

				$("body").css({
					"height": "auto",
					"overflow": "auto"
				});
			});
			shade.show();
			//显示商品属性选择框并标识已为复选框绑定事件
			ele.slideDown().attr("data-bindEvent", "yes");
			$("body").css({
				"height": windowHeight + "px",
				"overflow": "hidden"
			});

		};
		obj.hide = function() {
			$("._shade").remove();
			ele.slideUp().attr("data-bindEvent", "yes");

			$("body").css({
				"height": "auto",
				"overflow": "auto"
			});
		};
		obj.hasChooseStandard = function() { /*判断用户是否有选择商品属性，如果没有则给提示*/
			var radios = $("#j_standard_choose").find(":radio"),
				category = {},
				isCheck = true;
			//对商品属性进行分类
			radios.each(function(index, item) {
				var name = $(this).prop("name");
				if(name in category) {
					category[name].push($(this));
				} else {
					category[name] = [$(this)];
				}
			});

			for(var attr in category) {
				var isChecked = true;
				$.each(category[attr], function(index, item) {
					//判断每种商品属性用户是否都有选中
					return isChecked = !item.prop("checked");
				});
				if(isChecked) {
					mui.toast("商品属性您还未全部选择！");
					isCheck = false;
					break;
				}
			}
			return isCheck;
		};

		if(!ele.data("bindEvent")) {
			tool.getStandardChoosed(ele);
		}
		return obj;
	},
	chooseAddress: function(ele, fn) {
		/*显示mui的省市区三级联动菜单，ele为触发按钮，fn为回调函数，当选择了地址后会执行回调函数，并传入一个对象，对象中有省市区*/
		if(!(ele && fn)) {
			return;
		}
		var cityPicker3 = new mui.PopPicker({
			layer: 3
		});
		cityPicker3.setData(cityData3);
		ele.on("tap", function() {
			var that = this;
			cityPicker3.show(function(items) {
				var obj = {
					"province": (items[0] || {}).text,
					"city": (items[1] || {}).text,
					"area": (items[2] || {}).text
				}
				fn.call(that, obj);
			});
		});
	},
	checkedAll: function(checkBox, checkboxsWraper, fn, fn2) {
		/*全选与取消全选。checkBox为"全选"对应的复选框，checkboxsWraper为你要全选哪里的复选框，
		 * checkboxsWraper必须为一个选择器，fn为复选框每次选中或不选中时的回调函数，
		 * fn2为复选框全部选中或全未选中后的回调函数*/
		if(!(checkBox && checkboxsWraper)) {
			throw new Error("必须传递点击的checkbox和包裹复选框的元素的class或id！");
		}
		var checkboxsWraperEle = $(checkboxsWraper),
			checkboxs = checkboxsWraperEle.find(":checkbox"),
			isAllChecked = true;
		checkBox.on("change", function() {
			checkboxsWraperEle.find(":checkbox").prop("checked", $(this).prop("checked"));
			if(fn2) {
				fn2($(this).prop("checked"));
			}
		});
		$("body").on("change", checkboxsWraper + " :checkbox", function() {
			//判断复选框是否全部选中，如果未全部选中则将"全选"复选框取消选中
			var isAllChecked = true;
			if(fn){
				fn.call(this);
			}
			checkboxs.each(function() {
				return isAllChecked = $(this).prop("checked");
			});
			if(!isAllChecked) {
				checkBox.prop("checked", false);
			} else {
				checkBox.prop("checked", true);
			}
		});
	},
	setLevel: function(ele) { //给打分的星星绑定点击事件，即给评价里的"评星"的星星绑定点击事件
		if(!ele) {
			throw new Error("必须传递包裹星星的元素！");
		}
		var stars = ele.children(".star");
		stars.each(function(index, item) {
			$(this).on("tap", function() {
				$(this).addClass("active").prevAll().addClass("active").end().nextAll().removeClass("active");
				ele.children(".appraise-level").val($(this).data("level") || (index + 1));
			});
		});
	},
	exitApp: function() {
		//首页返回键处理
		//处理逻辑：1秒内，连续两次按返回键，则退出应用；
		var first = null;
		var showMenu = null;
		mui.back = function() {
			if(showMenu) {
				closeMenu();
			} else {
				//首次按键，提示‘再按一次退出应用’
				if(!first) {
					first = new Date().getTime();
					mui.toast('再按一次退出应用');
					setTimeout(function() {
						first = null;
					}, 1000);
				} else {
					if(new Date().getTime() - first < 1000) {
						plus.runtime.quit();
					}
				}
			}
		};
	}
};
mui.plusReady(function() {
	plus.navigator.setStatusBarBackground('#3385FF'); //设置状态栏背景色
	plus.webview.currentWebview().setStyle({
		scrollIndicator: 'none'
	}); //关闭滑动条显示	
});