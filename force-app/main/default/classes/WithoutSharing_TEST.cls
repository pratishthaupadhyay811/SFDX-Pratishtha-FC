@isTest
private with sharing class WithoutSharing_TEST {

    @isTest
    private static void shouldUpdateWithoutSharing() {
        final String EXPECTED_NAME = 'Updated Name';

        User readOnlyUser =  TestSObjectProvider.createUserWithProfile('Read Only');
        Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;

        Test.startTest();
        DmlException unexpectedException;
        System.runAs(readOnlyUser) {
            try {
                opp.Name = EXPECTED_NAME;
                new WithoutSharing().doUpdate(opp);

            } catch(DmlException dmlEx) {
                unexpectedException = dmlEx;
            }
        }
        Test.stopTest();

        System.assertEquals(null, unexpectedException, 'No DML exception should be thrown');

        Opportunity updatedOpp = [SELECT Name FROM Opportunity WHERE Id = :opp.Id];

        System.assertEquals(EXPECTED_NAME, updatedOpp.Name, 'The record should be updated');
    }

    @isTest
    private static void shouldQueryWithoutSharing() {
        User readOnlyUser =  TestSObjectProvider.createUserWithProfile('Read Only');
        Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;

        Test.startTest();
        List<Opportunity> queriedOpps;
        System.runAs(readOnlyUser) {
            queriedOpps = new WithoutSharing().doQuery('SELECT Name FROM Opportunity WHERE Id = \'' + opp.Id + '\'');
        }
        Test.stopTest();

        System.assert(queriedOpps != null && !queriedOpps.isEmpty(), 'The query should return results');
    }


    @isTest
    private static void shouldDoCountQueryWithoutSharing() {
        User readOnlyUser =  TestSObjectProvider.createUserWithProfile('Read Only');
        Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;

        Test.startTest();
        Integer count;
        System.runAs(readOnlyUser) {
            count = new WithoutSharing().doCountQuery('SELECT COUNT() FROM Opportunity WHERE Id = \'' + opp.Id + '\'');
        }
        Test.stopTest();

        System.assertEquals(1, count, 'The count query should return results without sharing');
    }
}