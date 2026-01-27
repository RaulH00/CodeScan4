public with sharing class GC_ConfigSensitive { // Noncompliance depends on thresholds
    public Integer fib(Integer n){ if(n<=1)return n; return fib(n-1)+fib(n-2); }
    public Integer collatz(Integer n){ Integer c=0; while(n>1){ n = (n%2==0)?n/2:3*n+1; c++; } return c; }
    public Integer digitsum(Integer n){ Integer s=0; while(n>0){ s+=n%10; n/=10; } return s; }
    public Integer countEvens(List<Integer> xs){ Integer c=0; for(Integer v:xs) if(v%2==0) c++; return c; }
    public String describe(Account a){ return a.Name + ':' + a.Phone + ':' + a.Rating; }
    public String join(List<String> xs){ return String.join(xs,'/'); }
    public Boolean empty(String s){ return s==null || s.trim()==''; }
}
