local LinkedList = require "List.LinkedList"
local Node = require "List.Node"

local function main()
    local lst = LinkedList()
    local head = Node(11,nil)
    lst:addHead(head)
    lst:addTail(Node(22))
    lst:addTail(Node(33))
    print("打印链表：")
    lst:printList()
    print()

    print("在此处拷贝下：")
    local lst2 = lst:clone()
    print(" 打印拷贝链表：")
    lst2:printList()

    print()
    print("删除首端节点：")
    lst:delHead()
    lst:printList()
    print()
    print("删除末端节点：")
    lst:delTail()
    lst:printList()
    print()

    print("拷贝的对象：")
    lst2:printList()
    print()

    print("删除首端节点：")
    lst2:delHead()
    lst2:printList()
end

main()