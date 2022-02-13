public with sharing class AuthorizeDotNetController {
	
	public AuthorizeDotNetController() {
		
	}

	@AuraEnabled
	public static List<AuthorizeDotNetWrapper> getRecordsController(){
		try{			

			Integer index = 0;	        
	        List<AuthorizeDotNetWrapper.Fieldlist> listOfFieldWrapper = new List<AuthorizeDotNetWrapper.Fieldlist>();	       	        
	        List<AuthorizeDotNetWrapper> dataWraper = new List<AuthorizeDotNetWrapper>();
	  
	        //List of Parent object that hold all the record values
	        List<Product2> listOfProducts = new List<Product2>();	        
	        List<string> fieldsApiNameList = new List<string>{'Name','Description','UnitPrice','Quantity__c'};

	        listOfProducts =[SELECT Name,Description,(SELECT UnitPrice FROM PricebookEntries LIMIT 1),Quantity__c FROM Product2 LIMIT 5];
           
            //Loop over field set list to bind field and data values together 
            
            for(string fields :fieldsApiNameList){                
                listOfFieldWrapper.add(new AuthorizeDotNetWrapper.Fieldlist(fields));                				
            }
            system.debug('listOfFieldWrapper : ' + listOfFieldWrapper);
            
            //Add field wrapper list in data wrapper list
            dataWraper.add(new AuthorizeDotNetWrapper(listOfFieldWrapper,index));

	        if(listOfProducts.size() > 0){	         
            	for(Product2 dataValues : listOfProducts){
                	listOfFieldWrapper = new List<AuthorizeDotNetWrapper.Fieldlist>();                    
                    	for(string fields : fieldsApiNameList){
                            system.debug('listOfProducts : ' + dataValues + ' ####################### : ');
                        	if(fields.equals('UnitPrice')){
                                system.debug('product : ' + dataValues.PricebookEntries[0].get(fields));
                            	listOfFieldWrapper.add(new AuthorizeDotNetWrapper.Fieldlist(string.valueOF(dataValues.PricebookEntries[0].get(fields))));
                         	}                            
	                        else{
	                            string temp =string.valueOF(dataValues.get(fields));
	                            if(temp == null){
	                                temp = ' ';
	                            }
								listOfFieldWrapper.add(new AuthorizeDotNetWrapper.Fieldlist(temp));
                         	}
                     	}
                	index++;
                 	dataWraper.add(new AuthorizeDotNetWrapper(listOfFieldWrapper,index));
            	}
        	}
            for(Integer i = 0; i < dataWraper.size(); i++)
        	   System.debug('dataWraper : ' + dataWraper[i]);
        //return a string of data wraper type through JSON.serialize        
        return dataWraper;

		}
		catch(Exception errorMessage){
			system.debug('error : ' + errorMessage);
		}

		return null;
	}

	//Pay using Credit card
	@AuraEnabled
	public Static string  paymentGateWay(Integer cardNumber, Integer cvv, String mobile, Decimal amount,String shipAddress, string shipCity, String shipcountry,String firstName,String lastName,String Email,String Phone,String cart, String exprDate)
	{
		String msg = '';
		try{

			system.debug('paymentGateWay : ' + cardNumber + ' cvv : ' + cvv + ' mble : ' + mobile + ' amount : ' + amount);
			string items = '<lineItems>';
            List<Object> cartItems = (List<Object>) JSON.deserializeUntyped(cart);
            system.debug('cart : ' + cart);
            system.debug('list obj : ' + cartItems);
            for(Object obj : cartItems){
                String temp = String.valueOf(obj).remove('(').remove(')').remove('{').remove('}').remove('sObjectData').remove('fields').remove('=').remove(' ');
                String [] str = temp.split(',');
                items += '<lineItem><itemId>'+'243'+'</itemId><name>';
                items += str[1]+'</name><description>'+str[2]+'</description><quantity>'+str[4]+'</quantity><unitPrice>'+str[3]+'</unitPrice></lineItem>';
            }
            System.debug(items);
            items += '</lineItems>';
            System.debug(items);
            //create instance of HttpRequest to send httprequest 
            HttpRequest reqs = new HttpRequest();
            
            //set end point url which api is hit
            reqs.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
            
            reqs.setMethod('POST');
            System.debug(amount+' '+shipAddress); 
            //Set Merchant id, product details, description price, card detail etc.
            String reqBody = '<createTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"> <merchantAuthentication> <name>'+'6nHz85E5'+'</name> <transactionKey>'+'7czWUSqr37J96R7p'+'</transactionKey> </merchantAuthentication><transactionRequest><transactionType>'+'authCaptureTransaction'+'</transactionType><amount>'+amount+'</amount><payment><creditCard><cardNumber>'+ '5424000000000015' + '</cardNumber><expirationDate>'+exprDate+'</expirationDate><cardCode>'+cvv+'</cardCode></creditCard></payment><order><invoiceNumber>'+'INV-12345'+'</invoiceNumber><description>'+'Golf Supplies'+'</description></order>'+items+'<customer><id>'+'39432'+'</id><email>'+Email+'</email></customer><billTo><firstName>'+'\''+firstName+'\''+'</firstName><lastName>'+'\''+lastName+'\''+'</lastName><address>'+'\''+ shipAddress +'\''+'</address><city>'+'\''+shipCity+'\''+'</city><state>'+'TX'+'</state><zip>'+'44628'+'</zip><country>'+'\''+ shipcountry +'\''+'</country></billTo><shipTo><firstName>'+'\''+firstName+'\''+'</firstName><lastName>'+'\''+lastName+'\''+'</lastName><address>'+'\''+ shipAddress +'\''+'</address><city>'+'\''+ shipCity +'\''+'</city><state>'+'TX'+'</state><zip>'+'44628'+'</zip><country>'+'\''+shipcountry+'</country></shipTo></transactionRequest></createTransactionRequest>';
            reqs.setBody(reqBody); 
            system.debug(reqBody);
            //create instance of Http to get response of http request
            Http h = new Http(); 
            HttpResponse res = h.send(reqs);
            string resp = res.getBody();
            system.debug('response body : ' + resp);
            msg = 'Payment success fully done : ' + resp;

            String response = resp.substringBetween('<resultCode>', '</resultCode>');
	        if(response.equalsIgnoreCase('OK')){
	        	response = 'Trasaction is Success';
	        }
	        else{
	        	if(resp.substringBetween('<errorText>', '</errorText>') != null){
	        		response = resp.substringBetween('<errorText>', '</errorText>');
	        	}
	        }
	        System.debug('between : ' + response);

	        msg = response;
		}
		catch(Exception error){
			system.debug('error : ' + error);
		}

		return msg;
	}

	//Pay using echeck
	@AuraEnabled
	public static String eCheckPayment(String nameOnAccount, Integer routing, Integer accountNumber, String checkNumber, String product, String country, String address, String city, String firstName, Decimal totalAmount){
		String msg;
		try{			

			//Create Item list for request body
			String items = '<lineItems>';
			List<Object> cartItems = (List<Object>) JSON.deserializeUntyped(product);
            system.debug('cart : ' + product);
            system.debug('list obj : ' + cartItems);
            for(Object obj : cartItems){
                String temp = String.valueOf(obj).remove('(').remove(')').remove('{').remove('}').remove('sObjectData').remove('fields').remove('=').remove(' ');
                String [] str = temp.split(',');
                system.debug('str[4] : ' + str[1] + ' : ' + str[4]);
                system.debug('str : ' + str);
                items += '<lineItem><itemId>'+'243'+'</itemId><name>';
                items += str[1]+'</name><description>'+str[2]+'</description><quantity>'+str[4]+'</quantity><unitPrice>'+str[3]+'</unitPrice></lineItem>';
            }
            System.debug(items);
            items += '</lineItems>';
            System.debug(items);

			HttpRequest reqs = new HttpRequest();            
	        //set end point url which api is hit
	        reqs.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');        
	        reqs.setMethod('POST');
	        
	        String reqBody = '<createTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><merchantAuthentication><name>6nHz85E5</name><transactionKey>7czWUSqr37J96R7p</transactionKey></merchantAuthentication><refId>123456</refId><transactionRequest><transactionType>authCaptureTransaction</transactionType><amount>' + totalAmount + '</amount><payment><bankAccount><accountType>checking</accountType><routingNumber>' + '121042882' + '</routingNumber><accountNumber>' + '0123456789012' + '</accountNumber><nameOnAccount>'  + nameOnAccount + '</nameOnAccount></bankAccount></payment><order><invoiceNumber>INV-12345</invoiceNumber><description>Product Description</description></order>' + items + '<tax><amount>' + '4.26' +  '</amount><name>level2 tax name</name><description>level2 tax</description></tax><duty><amount>8.55</amount><name>duty name</name><description>duty description</description></duty><shipping><amount>4.26</amount><name>level2 tax name</name><description>level2 tax</description></shipping><poNumber>456654</poNumber><billTo><firstName>' + firstName + '</firstName><lastName>Johnson</lastName><company>Souveniropolis</company><address>' + address + '</address><city>' + city + '</city><state>' + 'TX' + '</state><zip>44628</zip><country>' + country + '</country></billTo><shipTo><firstName>' + firstName + ' </firstName><lastName>Bayles</lastName><company>Thyme for Tea</company><address>' + address + '</address><city>' + city +' </city><state>TX</state><zip>44628</zip><country>' + country + '</country></shipTo><customerIP>192.168.1.1</customerIP></transactionRequest></createTransactionRequest>';
            reqs.setBody(reqBody); 
	        system.debug(reqBody);
 
	        Http h = new Http(); 
	        HttpResponse res = h.send(reqs);
	        string resp = res.getBody();
	        system.debug('response body : ' + resp);
	        msg = 'Payment success fully  done : ' + resp;		        	        
	        
	        String response = resp.substringBetween('<resultCode>', '</resultCode>');
	        if(response.equalsIgnoreCase('OK')){
	        	response = 'Trasaction is Success';
	        }
	        else{
	        	response = resp.substringBetween('<errorText>', '</errorText>');
	        }
	        System.debug('between : ' + response);

	        msg = response;
	        
	    }
	    catch(Exception error){
	    	system.debug('error : ' + error);
	    	msg = error.getMessage();
	    }
	    return msg;

	}

}