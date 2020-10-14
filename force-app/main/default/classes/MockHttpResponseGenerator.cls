@isTest

global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        string strJson = '{"hits":['+ '{ "organization_id": "6933738", "ein": "13-4145441", "organization_name": "NPower NY, Inc.", "city": "Brooklyn", "state": "NY", "zip": "11201", "nteecode": "S02 (Management & Technical Assistance)", "participation": "Silver", "irs_subsection": "501(c)(3) Public Charity", "msa": "5600 New York, NY-NJ" }, { "organization_id": "6933739", "ein": "13-4145449", "organization_name": "American National Red Cross", "city": "Test", "state": "DC", "zip": "11201", "nteecode": "S02 (Management & Technical Assistance)", "participation": "Silver", "irs_subsection": "501(c)(3) Public Charity", "msa": "5600 New York, NY-NJ" } ], "telephones":[ '+ '{"telephone_id":"1480504","telephone_type_id":"1", "telephone_number":"212444-7241" } ],"addresses":[ '+ '{ "address_type_id":"7","address_line_1":"3 MetroTech Center","address_line_2":"Mezzanine Level","city":"Brooklyn","country_subdivision_abbrev":"NY","country_abbrev":"","postal_code":"11201" } ] }';
        res.setHeader('Content-Type', 'application/json');
        res.setBody(strJson);
        res.setStatusCode(200);
        return res;
    }
}