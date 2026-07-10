class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0:
            return False
        
        n = x
        result = 0
        
        while n > 0:
            last_digit = n % 10
            result = (result * 10) + last_digit
            n = n // 10
        
        return x == result
