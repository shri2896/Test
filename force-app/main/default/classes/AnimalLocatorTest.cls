@IsTest
public class AnimalLocatorTest {
    
    @isTest static void AnimalLocatorMock1(){
        Test.setMock(HttpCalloutMock.Class, new AnimalLocatorMock());
       	String str = AnimalLocator.getAnimalNameById(2);
        String expectedValue = 'Chicken';
    	System.assertEquals(str, expectedValue);
    }                    
}