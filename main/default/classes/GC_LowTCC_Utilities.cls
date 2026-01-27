public with sharing class GC_LowTCC_Utilities { // Potential Noncompliant when tccThreshold is high
    private Integer x; private String y;
    public String upper(String s){ return s==null?'':s.toUpperCase(); }
    public String lower(String s){ return s==null?'':s.toLowerCase(); }
    public String reverse(String s){ if(s==null)return ''; String r=''; for(Integer i=s.length()-1;i>=0;i--) r+=s.substring(i,i+1); return r; }
    public Integer sum(List<Integer> xs){ Integer t=0; for(Integer n:xs)t+=n; return t; }
    public Integer max(List<Integer> xs){ Integer m=-2147483648; for(Integer n:xs) if(n>m) m=n; return m; }
    public Integer min(List<Integer> xs){ Integer m=2147483647; for(Integer n:xs) if(n<m) m=n; return m; }
    public List<String> splitByComma(String s){ return s==null?new List<String>():s.split(','); }
    public String pad(String s,Integer n){ while(s.length()<n) s+=' '; return s; }
    public Boolean isPalindrome(String s){ if(s==null) return false; String r=reverse(s); return r==s; }
    public String repeat(String s,Integer n){ String r=''; for(Integer i=0;i<n;i++) r+=s; return r; }
}
