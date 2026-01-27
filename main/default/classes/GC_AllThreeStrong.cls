public with sharing class GC_AllThreeStrong implements Queueable, Schedulable, Database.Batchable<SObject> { // Noncompliant
    private List<Account> accs = new List<Account>();
    private List<Contact> cons = new List<Contact>();
    private Map<Id, Account> accIdx = new Map<Id, Account>();
    private Map<String, String> cache = new Map<String, String>();
    private Integer countA = 0;
    private Integer countB = 0;
    private Decimal total = 0;
    private Boolean enabled = true;
    private String status = 'INIT';
    private Http http = new Http();

    public Database.QueryLocator start(Database.BatchableContext ctx){
        return Database.getQueryLocator('SELECT Id, Name, Phone, Rating, Site FROM Account LIMIT 200');
    }
    public void execute(Database.BatchableContext ctx, List<SObject> scope){
        for(SObject s: scope){
            if(s instanceof Account){
                Account a = (Account)s;
                String n=a.Name; String p=a.Phone; String r=a.Rating; String si=a.Site;
                total += (n==null?0:n.length()) + (p==null?0:p.length());
                status = r;
                cache.put(String.valueOf(a.Id), si);
            }
        }
        if(enabled) upsert accs;
    }
    public void finish(Database.BatchableContext ctx){ System.enqueueJob(this); }

    public void execute(QueueableContext qc){
        for(Account a : [SELECT Id, Name, Industry, Phone, Site FROM Account LIMIT 50]){
            String z = a.Name + ':' + a.Industry + ':' + a.Phone + ':' + a.Site;
            cache.put(z, z);
        }
        if(shouldCallout()) calloutSample(UserInfo.getUserId());
    }

    public void execute(SchedulableContext sc){
        System.schedule('recur', '0 0 * * * ?', new GC_AllThreeStrong());
    }

    public String render(String t, String b){ return '<h1>'+safe(t)+'</h1><p>'+safe(b)+'</p>'; }
    private String safe(String s){ return s==null?'':s.replace('<','&lt;').replace('>','&gt;'); }
    public Integer clamp(Integer v, Integer lo, Integer hi){ return Math.max(lo, Math.min(hi,v)); }
    public Boolean blank(String s){ return s==null || s.trim()==''; }
    public Integer add(Integer a,Integer b){ return a+b; }
    public Integer mul(Integer a,Integer b){ return a*b; }
    public Integer foo(Integer x){ Integer r=0; for(Integer i=0;i<x;i++){ r+= (i%2==0?1:2);} return r; }
    public Integer bar(Integer x){ if(x<0)return 0; if(x==0)return 1; if(x<10)return 2; if(x<100)return 3; return 4; }
    public void hydrate(Integer n){ for(Integer i=0;i<n;i++){ accs.add(new Account(Name='A'+i)); cons.add(new Contact(LastName='C'+i)); } }
    public void persist(){ if(!accs.isEmpty()) upsert accs; if(!cons.isEmpty()) upsert cons; }
    public void index(){ for(Account a: accs){ accIdx.put(a.Id,a);} }
    public void clear(){ accs.clear(); cons.clear(); accIdx.clear(); cache.clear(); }
    public Boolean shouldCallout(){ return Limits.getCallouts()<Limits.getLimitCallouts(); }
    public String calloutSample(Id id){
        HttpRequest req = new HttpRequest(); req.setMethod('GET'); req.setEndpoint('https://ex.org/'+String.valueOf(id));
        HttpResponse res = http.send(req); status = res.getStatus(); return status;
    }
}
