({
    checkOptionRightOrWrong : function(component, event) {
        var opt = component.get('v.option');
        var isRadio = component.get('v.isRadio');
        var ans = component.get('v.correctanswer');

        if(isRadio){
            if(opt.isChecked && opt.Name != ans){
                component.set('v.status', 'wrong');
                component.getEvent('ansStatus').setParams({'ansStatus' : true}).fire();
            }
            else if(ans == opt.Name){
                component.set('v.status', 'right');
            }            
        }

        else{            
            var allAns = ans.split(',');

            if(opt.isChecked && !allAns.includes(opt.Name)){
                component.getEvent('ansStatus').setParams({'ansStatus' : true}).fire();
                component.set('v.status', 'wrong');
            }
            else if(allAns.includes(opt.Name)){
                component.set('v.status', 'right');
            }
        }
    }
})