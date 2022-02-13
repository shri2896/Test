({
	doInit : function(component, event, helper) {
		
      jQuery("document").ready(function(){
          console.log('helloo')
          
      });
    },
    
    buttonHandler: function (component, event, helper) {
      	console.log('button is pressed');
		var firstP = $("p:first").text();
        var lastP = $("p:last").text();    

       	console.log('p: ',firstP);       //input: “p: Hello, I'm here!”
        console.log('p: ',lastP);        //input: “p: Second paragraph”
        
        $("input").attr({
            placeholder: 'Please enter a valid value'
        })
        
        var str = "77";
        
        if(str === 77){
            console.log('true');
        }
        else{
            console.log('false');
        }
        
   },
})