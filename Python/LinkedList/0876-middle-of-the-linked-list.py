class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution:
    def middleNode(self, head: ListNode) -> ListNode:
    
        length = 0
        temp = head
        while temp:
            length += 1
            temp = temp.next
    
        temp = head
        for i in range(0, length //2):
            temp = temp.next
        
        return temp
    
head = ListNode(1)

second = ListNode(2)
head.next = second


third = ListNode(3)
second.next = third

fourth = ListNode(4)
third.next = fourth


fifth = ListNode(5)
fourth.next = fifth

sol = Solution()
result = sol.middleNode(head)

print(result.val)  
