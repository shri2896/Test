@IsTest
public class ParkLocatorTest {
	@IsTest static void ParkLocatorGetCountry(){
		Test.setMock(WebServiceMock .class, new ParkServiceMock());
		String countryName = 'India';
		List<String> parkName = ParkLocator.country(countryName);		
	}
	 
}