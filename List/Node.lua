local Object = require "Object"

local Node = Object:extend()

function Node:new(i,nt)
    self.data = i or 0  --> int 数据域
    self.next = nt  --> Node 指向下一个节点
end

return Node