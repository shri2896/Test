import { LightningElement, track } from 'lwc';
import ProgressBarImges from '@salesforce/resourceUrl/ProgressBarImges';

export default class ProgressBarofLWC extends LightningElement {
    /* eslint-disable no-console */
    @track disableToNext = false;
    @track disableToPrevious = true;
    @track imgToShow = [];
    @track updateToimage = [];    
    @track checkMark;
    @track activeImg = [ProgressBarImges + '/Info_active.svg', ProgressBarImges +  '/Products-active.svg', ProgressBarImges +  '/Documents-active.svg', ProgressBarImges + '/Submit-active.svg', ProgressBarImges + '/Deliverables-active.svg'];
    @track defaultImg = [ProgressBarImges + '/info-default.svg', ProgressBarImges + '/Product-default.svg', ProgressBarImges + '/Documents-default.svg', ProgressBarImges + '/Submit-default.svg', ProgressBarImges + '/Deliverables-default.svg'];
    @track currentIcon = 0;

    connectedCallback(){        
        this.checkMark = ProgressBarImges + '/checkmark-complete.svg';
        this.imgToShow = [ProgressBarImges + '/Info_active.svg', ProgressBarImges + '/Product-default.svg', ProgressBarImges + '/Documents-default.svg', ProgressBarImges + '/Submit-default.svg',  ProgressBarImges + '/Deliverables-default.svg']
    }

    onNext(){
        this.currentIcon++;
        this.disableToPrevious = false;

        for (let index = 0; index < this.imgToShow.length; index++) {
            if(index < this.currentIcon){
                this.updateToimage.push(this.checkMark);
            }
            else if(this.currentIcon === index){        
                this.updateToimage.push(this.activeImg[index]);
            }
            else{                                
                this.updateToimage.push(this.imgToShow[index]);
            }
        }

        this.imgToShow = [];
        this.setData(this.updateToimage);        
        this.updateToimage = [];

        if(this.currentIcon === this.activeImg.length){
            this.disableToNext = true;
        }        
    }

    onPrevious(){
        this.disableToNext = false;
        this.currentIcon--;
        
        for(let index = 0; index < this.imgToShow.length; index++){
            if(index < this.currentIcon){
                this.updateToimage.push(this.imgToShow[index]);
            }
            else if(index === this.currentIcon){
                this.updateToimage.push(this.activeImg[index]);
            }
            else{
                this.updateToimage.push(this.defaultImg[index]);
            }
        }

        this.setData(this.updateToimage);
        this.updateToimage = [];

        if(this.currentIcon === 0){
            this.disableToPrevious = true;
        }
    }

    setData(lstOfData){
        this.imgToShow = [];        

        for(let index = 0; index < lstOfData.length; index++){            
            this.imgToShow.push(lstOfData[index]);
        }        
    }
    
}