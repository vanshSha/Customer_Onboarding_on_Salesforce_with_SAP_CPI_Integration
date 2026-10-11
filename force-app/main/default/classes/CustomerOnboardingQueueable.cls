public class CustomerOnboardingQueueable implements Queueable, Database.AllowsCallouts  {

    private Set<Id> accountIds;

    public CustomerOnboardingQueueable(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {

    List<Account> accounts = [
        SELECT Id, Name, Phone, BillingCity, BillingCountry,
               SAP_ID_c__c
        FROM Account
        WHERE Id IN :accountIds
    ];

    List<Account> accountsToUpdate = new List<Account>();

    for (Account account : accounts) {

        HttpResponse response =
            SapCustomerLookupClient.sendLookup(account);

        System.debug('SAP LOOKUP STATUS = ' + response.getStatusCode());
        System.debug('SAP LOOKUP RESPONSE = ' + response.getBody());

        if (response.getStatusCode() == 200) {

            SapCustomerLookupClient.LookupResponse result =
                SapCustomerLookupClient.parseLookupResponse(response);

           if (result.exists == true) {

    account.SAP_ID_c__c = result.sapId;

    System.debug(
        'EXISTING SAP CUSTOMER FOUND. SAP ID = '
        + result.sapId
    );

    accountsToUpdate.add(account);

} else if (result.success == true) {

    account.SAP_ID_c__c = result.sapId;

    System.debug(
        'NEW SAP CUSTOMER CREATED. SAP ID = '
        + result.sapId
    );

    accountsToUpdate.add(account);
}
        }
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}

}