public with sharing class HardcodedDomainController {
    public String redirectUrl { get; set; }

    public HardcodedDomainController() {
        // Hardcoded domain in Apex string
        redirectUrl = 'https://acme.my.salesforce.com/001';
    }

    public PageReference goToAccount() {
        // Hardcoded Lightning base
        String url = 'https://acme.lightning.force.com/lightning/r/Account/' + '001' + '/view';
        return new PageReference(url);
    }
}
