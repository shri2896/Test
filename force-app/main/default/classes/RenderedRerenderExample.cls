public with sharing class RenderedRerenderExample
{
    public boolean value1{get;set;}
    public boolean value2{get;set;}
    public boolean value3{get;set;}
    
    public RenderedRerenderExample()
    {
        value1=true;
        value2=false;
        value3=false;
    }
    
    public PageReference showsection1()
    {
        value1=true;
        value2=false;
        value3=false;
        return null;
    }
    
    public pagereference showsection2()
    {
        value1=false;
        value2=true;
        value3=false;
        return null;
    }
    
    public pagereference showsection3()
    {
        
        value1=false;
        value2=false;
        value3=true;
        return null;
    }
}