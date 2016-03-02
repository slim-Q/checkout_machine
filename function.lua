package.path =  '?.lua;;'
require "config"
local json = require "cjson"
local json_safe = require "cjson.safe"
local _M = { _VERSION = '2.01' }
--检查商品是否存在优惠
--@param id 商品ID
--@return flag 商品优惠标识 flag＝1 打折优惠 flag＝2 满减优惠 flag=0 没有相应商品的优惠
function check_promotion(id)
	local flag = 0 --促销种类标识 
	for _,good in pairs (sales["discounts"].goods) do 
   		if id == good then
                	flag = 1 
        	end
    	end
	for _,good in pairs (sales["down"].goods) do
		if id == good then
			flag = 2
		end
	end
	return flag
end

--数据输入转换
--@param json_text 传入模块的json数据
--@return table_order 订单汇总 table类型
function _M.input_order(json_text)
	local table_json = json.decode(json_text) --解析json
	local table_order = {} 
	for _, id_org in pairs(table_json) do
		local id , numb = string.match(id_org,'(.*)-(.*)')
		--累计商品数量
		if numb then
			table_order[id]=(table_order[id] or 0)+tonumber(numb)
		else
			table_order[id_org]=(table_order[id_org] or 0 )+ 1
		end
	end
	return table_order
end

--订单处理主函数
--@param table_order 订单汇总table
--@return table_result 订单结算后的信息 table类型
function _M.run(table_order)
	--定义订单结算结果信息table结构
	local table_result = {
		list = {},
		--table_down = {},
		table_total = {
			save_total = 0,
			bill_total = 0
		}
	}
	--遍历订单汇总信息中的商品信息，分条记账
	for id ,numb in pairs(table_order) do
		local unit = goods_list[id].unit --获取商品单位
		local name = goods_list[id].name --获取商品名称
		local price = string.format("%.2f", goods_list[id].price) --获取商品单位
		local bill = 0 --定义单项小计费用
		local save = 0 --定义单项节省费用
		local promotion_flag = check_promotion(id) --查询商品优惠信息
		--打折活动
		if promotion_flag == 1 then
			local discounts = sales["discounts"].value
			bill = string.format("%.2f",numb*price*discounts)
			save = string.format("%.2f",numb*price*(1-discounts))
			table.insert(table_result.list,"名称："..name.."数量："..numb..unit.." 单价："..price.."(元) 小计："..bill.."(元) 节省："..save.."(元)")
		--满减活动
		elseif promotion_flag == 2 then
			local value = sales["down"].value
			table_result.table_down[name] = math.modf(numb/value)..unit
			bill = string.format("%.2f",(numb-math.modf(numb/value))*price)
			save = math.modf(numb/value)*price
			table.insert(table_result.list,"名称："..name.." 数量："..numb..unit.." 单价："..price.."(元) 小计："..bill.."(元)")
		--该商品没有活动
		else
			bill = string.format("%.2f",numb*price)
			table.insert(table_result.list,"名称："..name.." 数量："..numb..unit.." 单价："..price.."(元) 小计："..bill.."(元)")
		end
		table_result["table_total"].bill_total = table_result["table_total"].bill_total + bill  --累计总计费用
		table_result["table_total"].save_total = table_result["table_total"].save_total + save  --累计节省费用
	end	-- body
	return table_result
end

--订单打印函数
--@param table_reslut 处理完成的订单结算信息
function _M.print_balance(table_result)
	print("***<没钱赚商店>购物清单***") 
	--打印订单明细
	for _,list_detail in pairs (table_result["list"]) do  
		print(list_detail)
	end
	print("----------------------")
	--若存在满减商品，打印明细
	if table_result["table_down"] then
		print("买二赠一商品：")
		for k,v in pairs (table_result["table_down"]) do
			print("名称：",k,"数量：",v)
		end
		print("----------------------")
	end
	--打印统计
	print("总计：",string.format("%.2f",table_result["table_total"].bill_total).."(元)")
	print("节省：",string.format("%.2f",table_result["table_total"].save_total).."(元)")
	print("**********************")
end
return _M
