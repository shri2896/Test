public class ParkLocator{
    public static List<String> country(String str){
        ParkService.ParksImplPort park = new ParkService.ParksImplPort();
        List<String> lst = park.byCountry(str);        
        return lst;
    }
}