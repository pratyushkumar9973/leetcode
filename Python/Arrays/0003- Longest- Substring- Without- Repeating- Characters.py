class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        charset = set()
        left=0
        res = 0
        for i in range(len(s)):
            while s[i] in charset:
                charset.remove(s[left])
                left +=1 
            charset.add(s[i])
            res = max(res, i-left+1)
        return res
