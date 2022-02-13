import { LightningElement, track, api} from 'lwc';

export default class ProgressBarChildComponent extends LightningElement {
    
    /* eslint-disable no-console */

    @track name;
    @api index;

    connectedCallback(){
        console.log('index : ', this.index)

        if(this.index === 0){
            this.name = 'Info';
        }
        else if(this.index === 1){
            this.name = 'Products';
        }
        else if(this.index === 2){
            this.name = 'Documents';
        }
        else if(this.index === 3){
            this.name = 'Submit';
        }
        else if(this.index === 4){
            this.name = 'Deliverable';
        }
    }
}