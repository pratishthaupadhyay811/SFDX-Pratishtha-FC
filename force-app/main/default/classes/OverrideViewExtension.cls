Global with sharing class OverrideViewExtension
{
       Global Boolean IsCommunityuser {get;set;}
       Global PageReference communityUrl{get;set;}

       Global OverrideViewExtension (ApexPages.StandardController controller){
           IsCommunityuser = false;

           FCGlobal.PageRedirectURL ObjPageRedirectURL = new FCGlobal.PageRedirectURL();

           ObjPageRedirectURL = FCGlobal.getRedirectURL();

           if(ObjPageRedirectURL != null){
               IsCommunityuser = ObjPageRedirectURL.IsCommunityuser;
               communityUrl = ObjPageRedirectURL.communityUrl;
           }
       }
}