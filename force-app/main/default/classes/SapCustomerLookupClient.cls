public class SapCustomerLookupClient {

    public static String buildLookupPayload(Account account) {

        Map<String, Object> payload = new Map<String, Object>{
            'customerName' => account.Name,
            'phone'        => account.Phone,
            'city'         => account.BillingCity,
            'country'      => account.BillingCountry
        };

        return JSON.serialize(payload);
    }

    public static HttpResponse sendLookup(Account account) {

        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:SAP_CPI_Customer_Lookup');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        String payload = buildLookupPayload(account);

        request.setBody(payload);

        System.debug('SAP LOOKUP REQUEST = ' + payload);

        Http http = new Http();

        return http.send(request);
    }

    public static LookupResponse parseLookupResponse(HttpResponse response) {

        LookupResponse result =
            (LookupResponse) JSON.deserialize(
                response.getBody(),
                LookupResponse.class
            );

        return result;
    }

    public class LookupResponse {

    public Boolean exists;
    public Boolean success;
    public String sapId;
}

}