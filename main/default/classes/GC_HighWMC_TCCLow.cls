public with sharing class GC_HighWMC_TCCLow { // Potential Noncompliant based on thresholds
    private String a; private String b; private String c;
    public Integer m1(Integer x){ return x+1; }
    public Integer m2(Integer x){ return x-1; }
    public Integer m3(Integer x){ Integer s=0; for(Integer i=0;i<x;i++) s+=i; return s; }
    public Integer m4(Integer x){ if(x<0)return 0; if(x==0)return 1; return x; }
    public String  m5(String s){ return s==null?'':s.trim(); }
    public String  m6(String s){ return s==null?'':s.toUpperCase(); }
    public String  m7(String s){ return s==null?'':s.toLowerCase(); }
    public Integer m8(Integer x){ Integer r=1; for(Integer i=1;i<=x;i++) r*=i; return r; }
    public Integer m9(Integer x){ Integer r=0; for(Integer i=0;i<x;i++) if(i%3==0) r++; return r; }
    public Boolean m10(String s){ return s==null || s==' '; }
    public String  m11(String s){ return String.valueOf(s); }
    public String  m12(List<String> ss){ return String.join(ss, ','); }
    public String  m13(String s){ return s+'!'; }
    public String  m14(String s){ return s+'?'; }
    public String  m15(String s){ return s+'.'; }
    public String  m16(String s){ return s+'~'; }
    public String  m17(String s){ return s+'#'; }
    public String  m18(String s){ return s+'@'; }
    public String  m19(String s){ return s+'$'; }
    public String  m20(String s){ return s+'%'; }
    public String parse(Account acc){ return acc.Name + ':' + acc.Industry; }
}
