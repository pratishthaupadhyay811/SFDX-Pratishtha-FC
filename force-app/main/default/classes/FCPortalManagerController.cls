public with sharing class FCPortalManagerController {
    public Map<String, PageReference> getPageLayoutConfiguration(){
        return new Map<String, PageReference>{
            'Design PageLayout/View existing page layout' => Page.PageLayout,
            'Design an Application/View existing Application' => Page.QuizDesignForm,
            'Add/Edit Profile Tab' => Page.TabGenerator
        };
    }

    public Map<String, PageReference> getGlobalConfiguration(){
        return new Map<String, PageReference>{
            'Configure GuideStar Field Mapping' => Page.GuidestarConfiguration,
            'Global Configuration of Community' => Page.PageLayout,
            'Portal User Field Mapping' => Page.PortalUserFieldMapping,
            'Community User Field Mapping' => Page.CommunityUserFieldMapping,
            'Configure State and Countries' => Page.CommunityStateCountryConfig,
            'Object Data Mapping Wizard ' => Page.ObjectDataTranslation
        };
    }
}