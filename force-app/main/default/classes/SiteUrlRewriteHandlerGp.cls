global  class SiteUrlRewriteHandlerGp implements Site.UrlRewriter {

    global static PageReference mapRequestUrl(PageReference myFriendlyUrl){
        if(myFriendlyUrl != null){
            String url = myFriendlyUrl.getUrl();
            if(url != null && (url.startsWith('/_ui/'))){
                if(!(url.startsWith('/_ui/networks/'))){
                    if(!(url.startsWith('/_ui/common/'))){
                        PageReference pageRef = page.fgm_portal__communitydashboard ;
                        return pageRef;
                    }
                }
            }
        }
        return null;
    }
    global static PageReference[] generateUrlFor(PageReference[] NOT_FOUND_PAGE)
    {
        return null;
    }

}