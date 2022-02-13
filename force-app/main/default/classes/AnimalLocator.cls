public class AnimalLocator {
    public static String getAnimalNameById(Integer ID){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String returnValue='';         
        if(response.getStatusCode()==200){
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());   
            System.debug('Result : ' + result);
            map<String, Object> animals = (map<String, Object>)result.get('animal');
            System.debug(animals);  
			returnValue = String.valueOf(animals.get('name'));
        }                
        return returnValue;        
    }

}