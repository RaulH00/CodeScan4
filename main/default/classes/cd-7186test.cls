//
// File: HardcodedUrlExamples.cls
//
public with sharing class HardcodedUrlExamples {

    // ============================
    // BAD: Hardcoded absolute URLs
    // ============================

    // VIOLATION: *.salesforce.com
    public PageReference badSalesforceDotCom() {
        String fullUrl = 'https://bad-practice.salesforce.com/apex/TestPage?some=thing';
        PageReference newUrl = new PageReference(fullUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // VIOLATION: *.force.com
    public PageReference badForceDotCom() {
        String fullUrl = 'https://mydomain.force.com/apex/TestPage?some=thing';
        PageReference newUrl = new PageReference(fullUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // VIOLATION: *.site.com  (Experience Cloud "my.site.com" style)
    public PageReference badSiteDotCom() {
        String fullUrl = 'https://mycompany.my.site.com/s/community?id=123';
        PageReference newUrl = new PageReference(fullUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // VIOLATION: *.documentforce.com (Content/Files CDN)
    public PageReference badDocumentforceDotCom() {
        String fullUrl = 'https://mydomain.documentforce.com/servlet/servlet.ImageServer?id=015000000000AAA';
        PageReference newUrl = new PageReference(fullUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // VIOLATION: *.marketingcloudapis.com (Marketing Cloud APIs)
    public PageReference badMarketingCloudApisDotCom() {
        String fullUrl = 'https://mc123abcgtsdx-0dtx0hh0gphn8.rest.marketingcloudapis.com/messaging/v1/email/messages';
        PageReference newUrl = new PageReference(fullUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // ==================================================
    // GOOD: Relative / environment-safe URL construction
    // ==================================================

    // Preferred: Build from org base URL (works across sandboxes/prod)
    public PageReference goodRelativeFromBase() {
        String base = URL.getSalesforceBaseUrl().toExternalForm(); // e.g., https://mydomain.my.salesforce.com
        String relativeUrl = base + '/apex/TestPage?some=thing';
        PageReference newUrl = new PageReference(relativeUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // Alternative: Use org domain URL helper (API may vary by runtime)
    public PageReference goodRelativeFromOrgDomain() {
        String base = System.Url.getOrgDomainUrl().toExternalForm(); // e.g., https://mydomain.my.salesforce.com
        String relativeUrl = base + '/lightning/page/home';
        PageReference newUrl = new PageReference(relativeUrl);
        newUrl.setRedirect(true);
        return newUrl;
    }

    // If linking to a known Experience Cloud site, derive host dynamically
    // from Site.getSiteDomain() (when running in that site context) instead
    // of hardcoding "my.site.com".
    public PageReference goodExperienceCloudLink() {
        // Falls back to org base if not on a Site
        String host = (Site.getSiteDomain() != null && Site.getSiteDomain() != '')
            ? 'https://' + Site.getSiteDomain()
            : URL.getSalesforceBaseUrl().toExternalForm();

        // Example community-relative path
        String url = host + '/s/article/example-article';
        PageReference pr = new PageReference(url);
        pr.setRedirect(true);
        return pr;
    }

    // ==================================================
    // OPTIONAL: Helper to validate/guard against bad hosts
    // (Useful for runtime checks in addition to static rules)
    // ==================================================
    public static Boolean isForbiddenHost(String absoluteUrl) {
        if (String.isBlank(absoluteUrl)) return false;
        // Normalize
        String u = absoluteUrl.toLowerCase();
        // Add or adjust patterns as needed
        List<String> blocked = new List<String>{
            '.salesforce.com',
            '.force.com',
            '.site.com',
            '.documentforce.com',
            '.marketingcloudapis.com'
        };
        for (String suffix : blocked) {
            // Match any subdomain of the blocked suffix
            if (u.startsWith('https://') && u.contains('//' ) ) {
                // crude host extraction without URI class
                String host = u.substringAfter('://').substringBefore('/');
                if (host.endsWith(suffix)) return true;
            }
        }
        return false;
    }

    // Example use of the guard (defensive programming)
    public PageReference guardedRedirect(String candidateUrl) {
        // If an absolute forbidden URL was passed, fall back to a safe relative route
        if (isForbiddenHost(candidateUrl)) {
            String safe = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/TestPage?safe=1';
            PageReference prSafe = new PageReference(safe);
            prSafe.setRedirect(true);
            return prSafe;
        }
        // Otherwise, use the provided URL as-is (still prefer relative internally)
        PageReference pr = new PageReference(candidateUrl);
        pr.setRedirect(true);
        return pr;
    }
}
