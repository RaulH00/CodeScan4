public with sharing class GC_HighATFD_Primary { // Potential Noncompliant based on thresholds
    public String summarize(Account a, Contact c, Opportunity o){
        String s = (a==null?'':a.Name) + '|' + a.Industry + '|' + a.Phone + '|' + a.Rating + '|' + a.Site;
        s += '::' + (c==null?'':c.FirstName) + ' ' + c.LastName + ' ' + c.Email + ' ' + c.Phone;
        s += '::' + (o==null?'':o.Name) + ' ' + o.StageName + ' ' + o.LeadSource + ' ' + o.Type;
        return s;
    }
    public String massTouch(List<Account> accs){
        String out='';
        for(Account a: accs){
            out += a.Name + a.Phone + a.Website + a.BillingCity + a.BillingCountry + a.Rating + '\n';
        }
        return out;
    }
    public String join(List<String> xs){ return String.join(xs, ','); }
}
