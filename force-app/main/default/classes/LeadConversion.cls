public class LeadConversion
{
    public static string[] UpdateLeadsOpportunities(Lead[] arrOldLeads, Lead[] arrNewLeads)
    {
      String[] arrStrError = new String[1];
      List<Lead> lstCloneLeads = new List<Lead>();

      Map<ID,Lead> mapConvertedLeads = new Map<ID,Lead>();
      Map<ID,Lead> mapOpportnuity_CloneLead = new Map<ID,Lead>();

      for(Integer iIndex=0 ; iIndex < arrNewLeads.size() ; iIndex++)
      {
          if(arrOldLeads[iIndex].IsConverted == false && arrNewLeads[iIndex].IsConverted == true)
          {
              if(arrNewLeads[iIndex].ConvertedOpportunityId != null)
              {
                  Lead CloneLead = arrNewLeads[iIndex].Clone(false,true);
                  CloneLead.Isconverted = false;
                  lstCloneLeads.add(CloneLead);
                  mapOpportnuity_CloneLead.put( arrNewLeads[iIndex].ConvertedOpportunityId,CloneLead);
                  mapConvertedLeads.put(arrNewLeads[iIndex].id,arrNewLeads[iIndex]);
              }
          }
      }
      SavePoint sp = Database.setSavepoint();

      if(mapOpportnuity_CloneLead.size() > 0)
      {
         //Updating the Lead reference in Opportunity with the clone Lead reference
         List<Opportunity> lstUpdateOpportunit = new List<Opportunity>();
         for(String OpportunityID : mapOpportnuity_CloneLead.keySet()) {
            Opportunity opportunity = new Opportunity(Id=OpportunityID);
         }

         Portal_Permission__c[] arrPortalPermission;
         Map<ID,Portal_Permission__c> mapLeadID_PortalPermission = new Map<ID,Portal_Permission__c>();


         if (mapConvertedLeads.size() > 0) {

             arrPortalPermission = [
                SELECT
                    Account__c,
                    Lead__c,
                    Opportunity__c,
                    Portal_Account__c
                FROM Portal_Permission__c
                WHERE Lead__c IN :mapConvertedLeads.keySet()
                WITH SECURITY_ENFORCED
            ];

         }

         for(Portal_Permission__c portalPermission : arrPortalPermission)
             mapLeadID_PortalPermission.put(portalPermission.Lead__c,portalPermission);

         for(Lead convertedLead : mapConvertedLeads.values())
         {
           Portal_Permission__c portalpermission = mapLeadID_PortalPermission.get(convertedLead.Id);
           if(portalpermission != null)
               portalpermission.Opportunity__c = convertedLead.ConvertedOpportunityId;
         }

         try
         {
            CrudFlsService.getInstance().assertUpdateable(arrPortalPermission);
             Database.update(arrPortalPermission);
         }
         catch(Exception ex)
         {
              Database.rollback(sp);
              arrStrError[0] = ex.getMessage();
              return arrStrError;
         }
      }
       return arrStrError;
    }
}