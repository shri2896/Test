import { LightningElement, track, api } from 'lwc';

export default class ChildComponentDemo extends LightningElement {
    /* eslint-disable no-console */
    @track message;
    @track textboxVal;

    @api
    childMessage(mssg){
        console.log('call');
        this.message = mssg;
    }

    handleChange(event){
        event.preventDefault();
        const name = event.target.value;
        console.log('target is : ', name);        
        const selectedEvent = new CustomEvent('mycustomevent',{detail: name});                                  
        this.dispatchEvent(selectedEvent);
    }    
}