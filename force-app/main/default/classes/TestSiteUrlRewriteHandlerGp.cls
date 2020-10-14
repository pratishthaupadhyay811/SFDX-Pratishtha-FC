@isTest
public class TestSiteUrlRewriteHandlerGp {
    static testmethod void mapRequestUrl(){
       PageReference pageReference = new PageReference('/_ui/networks');
       pageReference = SiteUrlRewriteHandlerGp.mapRequestUrl(pageReference);
       System.assert(pageReference != null);
       pageReference = SiteUrlRewriteHandlerGp.mapRequestUrl(null);
       System.assertEquals(null, pageReference);
    }
    static testmethod void generateUrlFor(){
        PageReference[] pageReference = SiteUrlRewriteHandlerGp.generateUrlFor(null);
        System.assertEquals(null, pageReference);
    }
}