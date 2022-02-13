//Use in helloWorldOfLWC

public with sharing class PDFFileController {        
    static List<Account> accLst;

    @AuraEnabled(cacheable=true)
    public static RecordWrapper nextPage(Decimal pageNumber){
        Integer pageSize = 5;        
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        
        accLst = [Select Id, Name, Industry from Account ORDER BY Name LIMIT 5 offset :offset];
        RecordWrapper rec = new RecordWrapper();        
        rec.currentPage =  (Integer)pageNumber;
        rec.pageSize = pageSize;
        rec.totalRecords = [Select count() from Account];
        rec.accLst = accLst;
        system.debug('first page : ' + rec);

        return rec;
    }

    public class RecordWrapper{
        @AuraEnabled public List<Account> accLst = new List<Account>();
        @AuraEnabled public Integer currentPage;
        @AuraEnabled public Integer pageSize;
        @AuraEnabled public Integer totalRecords;
    }

}