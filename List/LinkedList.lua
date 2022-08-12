local Object = require "Object"
local Node = require "List.Node"

local LinkedList = Object:extend()

function LinkedList:new()
    self.head = nil
    self.tail = self.head
    self.size = 0
end

function LinkedList:addHead(hd)
    assert(hd:is(Node))
    if self.size==0 then
        hd.next = hd
        self.head = hd
        self.tail = self.head
    else
        self.tail.next = hd
        hd.next = self.head
        self.head = hd
    end
    self.size = self.size + 1
end

function LinkedList:addTail(tl)
    assert(tl:is(Node))
    if self.size==0 then
        tl.next = tl
        self.tail = tl
        self.head = self.tail
    else
        self.tail.next = tl
        tl.next = self.head
        self.tail = tl
    end
    self.size = self.size + 1
end

function LinkedList:delHead()
    if self.size>1 then
        self.head = self.head.next
        self.tail.next = self.head
        self.size = self.size - 1
    elseif self.size == 1 then
        self.head = nil
        self.tail = self.head
        self.size = self.size - 1
    else
        print("There is no element in the linked list. Do nothing.")
    end
end

function LinkedList:delTail()
    if self.size>1 then
        local nd = Node()
        nd = self.head
        while nd.next ~= self.tail do
            nd = nd.next
        end
        nd.next = self.head
        self.size = self.size - 1
    elseif self.size == 1 then
        self.tail = nil
        self.head = self.tail
        self.size = self.size - 1
    else
        print("There is no element in the linked list. Do nothing.")
    end
end

function LinkedList:printList()
    local nd = Node()
    nd = self.head
    pcall(
        function ()
            local str = ""
            while nd.next ~= self.head do
                str = str..nd.data.."->"
                nd = nd.next
            end
            str = str..nd.data.."->"..self.head.data.."(head)"
            print(str)
        end
        )
end

return LinkedList

