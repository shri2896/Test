public with sharing class RenderExample 
{
    
    public boolean status1{get;set;}
    public boolean status2{get;set;}
    
    public RenderExample ()
    {
        status1=true;
        status2=false;
    }
    
    public void showSection1()
    {        
        status1=true;
        status2=false;
    }
    public void showSection2()
    {
        status1=false;
        status2=true;
    }
    
}