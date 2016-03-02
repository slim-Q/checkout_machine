# checkout_machine
实现一个收银机打印模块

### 文件说明
main.lua是主程序文件，模块输入json在该文件JSON_TEXT中定义.

function.lua是函数库文件.

config.lua是配置文件，包含了商品明细信息和商品优惠配置.
### 详细配置
	--商品优惠信息配置
	sales = {
		down = { goods = {  }, value = 3 }, --down满减活动 goods为参与活动的商品ID，value为3表示满三减一即满二赠一
		discounts = { goods = { "ITEM000003" }, value = 0.95 } --discounts打折活动，goods为参与活动的商品ID，value为0.95表示九五折
	}
	--商品信息
	--key是商品ID，值是商品名称、计价单位、单价、分类
	goods_list = {
		ITEM000005={ name="可口可乐",unit="瓶",price=3.00,group="饮料"},
		ITEM000003={ name="苹果",unit="斤",price=5.50,group="水果"},
		ITEM000001={ name="羽毛球",unit="个",price=1.00,group="日用"}
	}
### 附
解析json使用了lua-cjson库.

  地址https://github.com/mpx/lua-cjson.git .

在此感谢.

