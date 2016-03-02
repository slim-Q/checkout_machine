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
