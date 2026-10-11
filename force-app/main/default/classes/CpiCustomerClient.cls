public class CpiCustomerClient {

    public static HttpResponse sendCustomer(Account account) {

        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:SAP_CPI_Customer_On_boarding');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        Map<String, Object> payload = new Map<String, Object>{
            'customerName' => account.Name,
            'phone'        => account.Phone,
            'city'         => account.BillingCity,
            'country'      => account.BillingCountry
        };

        request.setBody(JSON.serialize(payload));
        System.debug('CPI REQUEST BODY = ' + request.getBody());


        Http http = new Http();

        return http.send(request);
    }

}