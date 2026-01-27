public class Foo {
    String fullUrl1 ='http://login.salesforce.com/';
    String fullUrl2 ='http://acme.my.salesforce.com/';
    String fullUrl3 ='http://some.force.com/';
    String fullUrl4 ='http://login.lightning.force.com/';
    String fullUrl5 ='http://login.my.site.com/';
    String fullUrl6 ='http://some.sandbox.my.salesforce.com/';
    String fullUrl7 ='http://cool.api.salesforce.com/';
    String fullUrl8 ='http://test.c.documentforce.com/';
    String fullUrl9 ='http://login.auth.marketingcloudapis.com/';
    public PageReference absoluteRedirect() {
        PageReference newUrl1 = new PageReference(fullUrl1);
        PageReference newUrl2 = new PageReference(fullUrl2);
        PageReference newUrl3 = new PageReference(fullUrl3);
        PageReference newUrl4 = new PageReference(fullUrl4);
        PageReference newUrl4 = new PageReference(fullUrl5);
        PageReference newUrl4 = new PageReference(fullUrl6);
        PageReference newUrl4 = new PageReference(fullUrl7);
        PageReference newUrl4 = new PageReference(fullUrl8);
        PageReference newUrl4 = new PageReference(fullUrl9);
        return null;
    }
}
