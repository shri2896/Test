({
	unWrapData: function(component, event){
		var lst = component.get("v.data");		
        var headerVal = component.get("v.header"); 
        //console.log("unWrapData : " + lst.length);
        var datalst = [];      

        var indexVal = component.get("v.checkboxIndex");

        for(var i=0; i<lst.length; i++){
        	var val = [];
        	var key = lst[i]
        	var obj = new Object();
		    
        	for(var head = 0; head<headerVal.length; head++){        		        		        		        		
        		val.push(key[headerVal[head].b]);
        		
        	}   
        	//val.push(key["index"]);
        	obj.key = val
        	obj.index = key["index"];                	                    

            var index = indexVal.indexOf(lst[i].index);
            if(index == -1){
                obj.checked = false;                
            }
            else{
                obj.checked = true;                                                
            }               
            datalst.push(obj)             
        }        
        component.set("v.showData", datalst);  	        

	},

	showModal: function(component, event){
		var headerVal = event.target.id;		
        //console.log("enter in modalComponent")
    	$A.createComponent('c:SearchModal',{     
            'headerText' : 'Search record for ' +  headerVal + ' header',
            'searchHeader' : headerVal
       	 },
        function(modalComponent, status, errorMessage){
            //console.log('model comp : ' + status)
            if(status == 'SUCCESS'){
                var body = component.find('searcModel').get("v.body")    
                body.push(modalComponent)
                component.find('searcModel' ).set("v.body", body);
            }
            else if (status === "INCOMPLETE") {
                //console.log('Server issue or client is offline.');
            } 
            else if (status === "ERROR") {
          	  //console.log('error');
            }
        })    
	},

	handleRemoveSearch: function(component, event, headerVal){
		var evnt = component.getEvent("removeSearching");		
		evnt.setParams({"removeSearching": headerVal}).fire();
	},

	setHeaderIcon: function(component, event){
		var headerLst = component.get("v.header");		
		
		var hlst = [];
		for(var i=0; i < headerLst.length; i++){			
			var obj = new Object();			
			obj.a = "false";
			obj.b = headerLst[i];
			hlst.push(obj);						
		}
		component.set("v.header", hlst);
		//console.log("table helper : " + JSON.stringify(hlst));
	}
})