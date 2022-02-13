@isTest
public with sharing class AuthorizeDotNetTest {
	
	public AuthorizeDotNetTest() {
		
	}

	 public static testmethod void authorizeResponse(){
		Test.setMock(HttpCalloutMock.class, new AuthorizeMockResponse());					                
         List<Product2> lstProd = new List<Product2>();
         
         for(Integer i = 0; i < 5; i++){
             Product2 prod = new Product2();
             prod.Name = 'product2 ' + i;
             prod.Description = 'Description ' + i;
             prod.Quantity__c = 10.5 * i;
             prod.Family = 'Mobile';
             lstProd.add(prod);
         }
         
         Pricebook2 standardPricebook = new Pricebook2(
             Id = Test.getStandardPricebookId(),
             IsActive = true
         );
         
         insert lstProd;
         
         PricebookEntry pbe = new PricebookEntry(
             Pricebook2Id = standardPricebook.Id,
             Product2Id = lstprod[0].Id,
             UnitPrice = 1020,
             IsActive = true
         );
         Insert pbe;                                   
         
        Test.startTest();               
        	AuthorizeDotNetController responseWrapper = new AuthorizeDotNetController();        	        	
         	
         	Integer cardNumber = 5424000;
         	Integer cvv = 999 ;
         	String mobile = '77371432' ;
         	Decimal amount = 6.5;
         	String shipAddress = '14 Main Street' ;
         	string shipCity = 'TX';
         	String shipcountry = 'USA';
         	String firstName = 'John';
         	String lastName = 'Doe' ;
         	String Email = 'shrikant.mittal@briskminds.com';
         	String Phone = '773714';
         	String cart = '[{"index":1,"sObjectData":[{"fields":"GenWatt Diesel 200kW"},{"fields":" "},{"fields":"25000.00"},{"fields":"1"}]}]';
         	String exprD = '2012-12';
        	
            AuthorizeDotNetController.paymentGateWay(cardNumber, cvv, mobile, amount,shipAddress, shipCity, shipcountry, firstName, lastName, Email, Phone, cart, exprD );         											         	
         	cart = '"index":1,"sObjectData":[{"fields":"GenWatt Diesel 200kW"},{"fields":" "},{"fields":"25000.00"},{"fields":"1"}]}]';
			AuthorizeDotNetController.paymentGateWay(cardNumber, cvv, mobile, amount,shipAddress, shipCity, shipcountry, firstName, lastName, Email, Phone, cart, exprD );         	
         	AuthorizeDotNetController.getRecordsController();         	
			AuthorizeDotNetController.eCheckPayment('Checking', 100, 100, 'chk100','[{"index":1,"sObjectData":[{"fields":"GenWatt Diesel 200kW"},{"fields":" "},{"fields":"25000.00"},{"fields":"1"}]}]', 'USA', '124 Main Street', 'TX', 'John', 100.1);         	
			AuthorizeDotNetController.eCheckPayment('Checking', 100, 100, 'chk100','[{"index":1,"sObjectData":[{"fields":"GenWatt Diesel 200kW"},{"fields":" "},{"fields":"25000.00"},{"fields":"1"]]', 'USA', '124 Main Street', 'TX', 'John', 100.1);         	         	
		test.stoptest();	                
    	       
	}   
	
}