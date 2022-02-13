public with sharing class AuthorizeMockResponse  implements HttpCalloutMock {
	public AuthorizeMockResponse() {
		
	}

	public HTTPResponse respond(HTTPRequest request) { 
		if(request.getEndpoint().contains('https://apitest.authorize.net/xml/v1/request.api')){
        	HttpResponse response = new HttpResponse();                    	
            //response.setBody('<?xml version="1.0" encoding="utf-8"?><createTransactionResponse><refId>123456</refId><messages><resultCode>Ok</resultCode><code>I00001</code><text>Successful.</text></message></messages><transactionResponse><responseCode>1</responseCode><authCode>UGELQC</authCode><avsResultCode>E</avsResultCode><cavvResultCode /><transId>2148061808</transId><refTransID /><transHash>0B428D8A928AAC61121AF2F6EAC5FF3F</transHash><accountNumber>XXXX5678</accountNumber><accountType>eCheck</accountType><message><code>1</code><description>This transaction has been approved.</description></message><userFields><userField><name>MerchantDefinedFieldName1</name><value>MerchantDefinedFieldValue1</value></userField><userField><name>favorite_color</name><value>lavender</value></userField></userFields></transactionResponse></createTransactionResponse>');							            
            response.setBody('<?xml version="1.0" encoding="utf-8"?><createTransactionResponse><refId>123456</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactionResponse><responseCode>1</responseCode><authCode /><avsResultCode>P</avsResultCode><cvvResultCode /><cavvResultCode /><transId>2214627492</transId><refTransID /><transHash>7A6DCD2645DF873C035DCE4832C08036</transHash><accountNumber>XXXXX6789</accountNumber><accountType>eCheck</accountType><messages><message><code>1</code><description>This transaction has been approved.</description></message></messages></transactionResponse></createTransactionResponse>');
            return response;
        }	
        else{
        	HttpResponse response = new HttpResponse();                    	
        	response.setBody('<?xml version="1.0" encoding="utf-8"?><createTransactionResponse><refId>123456</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactionResponse><responseCode>1</responseCode><authCode /><avsResultCode>P</avsResultCode><cvvResultCode /><cavvResultCode /><transId>2214627492</transId><refTransID /><transHash>7A6DCD2645DF873C035DCE4832C08036</transHash><accountNumber>XXXXX6789</accountNumber><accountType>eCheck</accountType><messages><message><code>1</code><description>This transaction has been approved.</description></message></messages></transactionResponse></createTransactionResponse>');
            
            return response;
        }
        return new HttpResponse();
	} 
}