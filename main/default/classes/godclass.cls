public with sharing class GodClassViolation implements Database.Batchable<SObject>, Queueable, Schedulable { // Noncompliant

    // === Bloated state (too many fields) ===
    private Map<String, Object> cache = new Map<String, Object>();
    private List<String> messages = new List<String>();
    private Set<Id> processedIds = new Set<Id>();
    private Integer retryCount = 0;
    private Decimal runningTotal = 0;
    private String lastStatus = 'INIT';
    private Boolean isEnabled = true;
    private Datetime startedAt;
    private Datetime endedAt;
    private Http http = new Http();
    private String baseUrl = 'https://example.org';
    private String apiKey = 'dummy';
    private List<Account> accBuffer = new List<Account>();
    private List<Contact> conBuffer = new List<Contact>();
    private Map<Id, Account> accIndex = new Map<Id, Account>();
    private Map<String, String> settings = new Map<String, String>();
    private Blob lastHash;
    private Integer maxItems = 1000;

    // === Batchable ===
    public Database.QueryLocator start(Database.BatchableContext ctx) {
        log('Batch start');
        return Database.getQueryLocator('SELECT Id, Name FROM Account LIMIT 50');
    }
    public void execute(Database.BatchableContext ctx, List<SObject> scope) {
        for (SObject s : scope) {
            if (s instanceof Account) {
                Account a = (Account)s;
                runningTotal += (a.Name != null ? a.Name.length() : 0);
                processedIds.add(a.Id);
            }
        }
        if (scope.size() > 0 && shouldCallExternal()) callExternalService(scope[0].Id);
    }
    public void finish(Database.BatchableContext ctx) {
        sendSummaryEmail('Batch finished with ' + processedIds.size() + ' items.');
    }

    // === Queueable ===
    public void execute(QueueableContext ctx) {
        log('Queueable execute');
        upsertBuffered();
        String csv = exportCsv(new List<String>{ 'a,b,c', '1,2,3' });
        messages.add(csv);
    }

    // === Schedulable ===
    public void execute(SchedulableContext ctx) {
        log('Schedulable execute');
        System.enqueueJob(this);
    }

    // === Unrelated utilities (low cohesion) ===
    public String renderHtmlCard(String title, String body) {
        return '<div class="card"><h1>' + escapeHtml(title) + '</h1><p>' + escapeHtml(body) + '</p></div>';
    }
    private String escapeHtml(String s) {
        return s == null ? '' : s.replace('<', '&lt;').replace('>', '&gt;');
    }

    public String exportCsv(List<String> rows) {
        String out = '';
        for (String r : rows) out += r + '\n';
        return out;
    }
    public List<List<String>> parseCsv(String csv) {
        List<List<String>> res = new List<List<String>>();
        for (String line : csv.split('\n')) res.add(line.split(','));
        return res;
    }

    public void upsertBuffered() {
        if (!accBuffer.isEmpty()) upsert accBuffer;
        if (!conBuffer.isEmpty()) upsert conBuffer;
    }

    public void indexAccounts(List<Account> accs) {
        for (Account a : accs) accIndex.put(a.Id, a);
    }

    public void loadSettings() {
        for (CustomSetting__c cs : [SELECT Name, Value__c FROM CustomSetting__c LIMIT 50]) {
            settings.put(cs.Name, cs.Value__c);
        }
    }

    public void log(String msg) {
        messages.add(Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' ' + msg);
        if (messages.size() > 500) messages.remove(0);
    }

    public Boolean shouldCallExternal() {
        return isEnabled && Limits.getCallouts() < Limits.getLimitCallouts();
    }

    public String callExternalService(Id sampleId) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(baseUrl + '/api/sample/' + String.valueOf(sampleId));
        req.setHeader('Authorization', 'ApiKey ' + apiKey);
        HTTPResponse res = http.send(req);
        lastStatus = res.getStatus();
        cache.put('lastCallBody', res.getBody());
        return lastStatus;
    }

    public String computeDigest(String input) {
        Blob b = Crypto.generateDigest('SHA-256', Blob.valueOf(input));
        lastHash = b;
        return EncodingUtil.convertToHex(b);
    }

    public Integer fuzzyScore(String a, String b) {
        if (a == null || b == null) return 0;
        Integer score = 0;
        Integer len = Math.min(a.length(), b.length());
        for (Integer i = 0; i < len; i++) {
            if (a.substring(i, i+1) == b.substring(i, i+1)) score++;
        }
        return score;
    }

    public void hydrateBuffer(Integer n) {
        for (Integer i = 0; i < n; i++) accBuffer.add(new Account(Name = 'A' + i));
        for (Integer j = 0; j < n; j++) conBuffer.add(new Contact(LastName = 'C' + j));
    }

    public void persistAll() {
        try {
            if (!accBuffer.isEmpty()) insert accBuffer;
            if (!conBuffer.isEmpty()) insert conBuffer;
        } catch (Exception e) {
            retryCount++;
            log('Persist failed: ' + e.getMessage());
        }
    }

    public void auditAndNormalize() {
        for (Account a : accBuffer) {
            if (a.Name == null || a.Name.trim() == '') a.Name = 'UNKNOWN';
            runningTotal += a.Name.length();
        }
    }

    // High-branch method to inflate complexity
    public String routingHub(String kind, Integer code) {
        String result = 'UNKNOWN';
        if (kind == null) return result;
        switch on kind.toLowerCase() {
            when 'acc' { result = (code % 2 == 0) ? 'EVEN' : 'ODD'; }
            when 'con' {
                if (code < 0) result = 'NEG';
                else if (code == 0) result = 'ZERO';
                else if (code < 10) result = 'SMALL';
                else if (code < 100) result = 'MEDIUM';
                else result = 'LARGE';
            }
            when else { result = 'OTHER'; }
        }
        if (result == 'OTHER' && shouldCallExternal()) result = callExternalService(UserInfo.getUserId());
        return result;
    }

    public void clearAll() {
        cache.clear(); messages.clear(); processedIds.clear();
        accBuffer.clear(); conBuffer.clear(); accIndex.clear(); settings.clear();
        runningTotal = 0; retryCount = 0;
    }

    // Many tiny “utility” methods (inflate method count, low cohesion)
    public String upper(String s){ return s == null ? '' : s.toUpperCase(); }
    public String lower(String s){ return s == null ? '' : s.toLowerCase(); }
    public String join(List<String> xs, String sep){ return String.join(xs, sep); }
    public Integer clamp(Integer v, Integer lo, Integer hi){ return Math.max(lo, Math.min(hi, v)); }
    public Boolean isEmpty(String s){ return s == null || s.trim() == ''; }
    public Integer add(Integer a, Integer b){ return a + b; }
    public Integer sub(Integer a, Integer b){ return a - b; }
    public Integer mul(Integer a, Integer b){ return a * b; }
    public Integer divz(Integer a, Integer b){ return b == 0 ? 0 : a / b; }
    public String summarize(){ return 'msgs=' + messages.size() + ', acc=' + accBuffer.size() + ', con=' + conBuffer.size(); }

    // padding methods to exceed thresholds if needed (duplicate these as necessary)
    public void noop1() {}
    public void noop2() {}
    public void noop3() {}
    public void noop4() {}
    public void noop5() {}
}
