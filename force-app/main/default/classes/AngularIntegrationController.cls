global class AngularIntegrationController {
    
    // hardcode an account id for demo purposes
    static String accountId = '0016F00002uK7qAQAS';
    
    global static String getAccount() {
        return JSON.serialize([select name, billingstreet,
                               billingcity, billingstate, billingpostalcode
                               from account where id = :accountId][0]);
    }
    global static String getOpportunity() {
        return JSON.serialize([select id, name,amount,ExpectedRevenue
                               from opportunity where accountId = :accountId]);
    }    
}