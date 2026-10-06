local Object <const> = require "Object"
local Node <const> = require "List.Node"

local LinkedList = Object:extend("List.LinkedList")

function LinkedList:new()
    self.head = nil
    self.tail = nil
    self.size = 0
end

function LinkedList:addHead(hd)
    assert(hd and hd:is(Node), "Argument of addHead must be a Node instance")
    if self.size == 0 then
        hd.next = hd
        self.head = hd
        self.tail = hd
    else
        self.tail.next = hd
        hd.next = self.head
        self.head = hd
    end
    self.size = self.size + 1
end

function LinkedList:addTail(tl)
    assert(tl and tl:is(Node), "Argument of addTail must be a Node instance")
    if self.size == 0 then
        tl.next = tl
        self.tail = tl
        self.head = tl
    else
        self.tail.next = tl
        tl.next = self.head
        self.tail = tl
    end
    self.size = self.size + 1
end

function LinkedList:delHead()
    if self.size > 1 then
        self.head = self.head.next
        self.tail.next = self.head
        self.size = self.size - 1
    elseif self.size == 1 then
        self.head = nil
        self.tail = nil
        self.size = 0
    else
        print("There is no element in the linked list. Do nothing.")
    end
end

function LinkedList:delTail()
    if self.size > 1 then
        local nd = self.head
        while nd.next ~= self.tail do
            nd = nd.next
        end
        nd.next = self.head
        self.tail = nd
        self.size = self.size - 1
    elseif self.size == 1 then
        self.head = nil
        self.tail = nil
        self.size = 0
    else
        print("There is no element in the linked list. Do nothing.")
    end
end

function LinkedList:clone()
    local newList <const> = LinkedList()
    if self.size == 0 or not self.head then
        return newList
    end
    local nd = self.head
    for _ = 1, self.size do
        newList:addTail(Node(nd.data))
        nd = nd.next
    end
    return newList
end

function LinkedList:printList()
    if self.size == 0 or not self.head then
        print("(empty)")
        return
    end
    local nd = self.head
    local parts <const> = table.create(self.size + 1, 0)
    for _ = 1, self.size do
        if nd.next == nd and self.size > 1 then
            table.insert(parts, nd.data .. "->" .. nd.data .. "(self)-x[unreachable]" .. self.head.data .. "(head)")
            print(table.concat(parts, "->"))
            return
        end
        table.insert(parts, tostring(nd.data))
        nd = nd.next
    end
    table.insert(parts, tostring(self.head.data) .. "(head)")
    print(table.concat(parts, "->"))
end

function LinkedList:__len()
    return self.size
end

-- 避免递归死循环
function LinkedList:__tostring()
    return "LinkedList(size=" .. tostring(self.size) .. ")"
end

return LinkedList
