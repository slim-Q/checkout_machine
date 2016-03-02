package.path =  '?.lua;;'
local machine = require "function"

--模块输入json
local JSON_TEXT = '["ITEM000001","ITEM000001","ITEM000001","ITEM000001","ITEM000001","ITEM000003-2","ITEM000005","ITEM000005","ITEM000005"]'
--解析统计输入
local table_order = machine.input_order(JSON_TEXT)
--结算
local table_result = machine.run(table_order)
--打印结算清单
machine.print_balance(table_result)
