import { LightningElement,api, track } from 'lwc';
import nextPage from '@salesforce/apex/PDFFileController.nextPage'

export default class HelloWorldOfLWC extends LightningElement {
   /* eslint-disable no-console */

    @track firstName = 'undefined';
    @track page = 1;
    @track pages;
    @track total;    
    @api lastName = 'mittal'
    @track textboxPageNumber;
    @track textval;

    isFirstDisabled = false;
    isNextDisabled = false;
    isLastDisabled = false;
    isPreviousDisabled = false;

    connectedCallback(){        
        nextPage({pageNumber : this.page})
        .then(result => {
            //console.log('initialize data : ', result)
            this.firstName = result.accLst;  
            this.page = result.currentPage;
            this.total = result.totalRecords;
            this.pages = Math.ceil(this.total / 5);
            //console.log('page : ', this.page, ' total page : ', this.pages, ' : total records : ', this.total);
            this.isFirstDisabled = true;

            if(this.page === this.pages){
                this.isNextDisabled = true;                
            }
            if(this.page === 1){
                this.isPreviousDisabled = true;
            }

        })
    }    
    
    onNextPage({data, error}){
        console.log('next page');
        this.page = this.page + 1;
        nextPage({pageNumber : this.page})
            .then(result => {
                this.firstName = result.accLst;
                this.page = result.currentPage;                
                this.total = result.totalRecords;
                this.pages = Math.ceil(this.total / 5);                

                this.isFirstDisabled = false;
                this.isPreviousDisabled = false;

                if(this.page === this.pages){
                    this.isNextDisabled = true;
                    this.isLastDisabled = true;
                }
                if(this.page === 1){
                    this.isPreviousDisabled = true;
                    this.isFirstDisabled = true;
                }                
                this.template.querySelector('c-child-Component-Demo').childMessage('this is parent string');                
            })
            .catch(err => {
                this.lastName = err;
            })
        if(data){
            this.firstName = data;
        }
        else if(error){
            this.lastName = error;
        }
    }

    onFirstPage(){        
        console.log('firstpage');
        nextPage({pageNumber : 1})
            .then(result => {
                this.firstName = result.accLst;
                this.page = result.currentPage;                
                this.total = result.totalRecords;
                this.pages = Math.ceil(this.total / 5);
                this.isFirstDisabled = true;
                this.isPreviousDisabled = true;

                if(this.page === this.pages){
                    this.isNextDisabled = true;
                }
                else{
                    this.isNextDisabled = false;
                }
                if(this.page === this.pages){
                    this.isLastDisabled = true;                    
                }
                else{                    
                    this.isLastDisabled = false;
                }
            })
            .catch(error => {
                this.lastName = error;
            }); 
    }

    onPreviousPage(){
        this.page-=1;
        nextPage({pageNumber : this.page})
            .then(result => {
                this.page = result.currentPage;
                this.firstName = result.accLst;
                this.total = result.totalRecords;
                this.pages = Math.ceil(this.total / 5);

                this.isNextDisabled = false;
                if(this.page !== 1){
                    this.isFirstDisabled = false;
                }else{
                    this.isFirstDisabled = true;
                }

                if(this.page === 1){
                    this.isPreviousDisabled = true;
                }else{
                    this.isPreviousDisabled = false;
                }
                if(this.page === this.pages){
                    this.isLastDisabled = true;
                }
                else{
                    this.isLastDisabled = false;
                }

            })
            .catch(error => {
                console.log('error in previous : ', JSON.stringify(error));
            })
    }

    onLastPage(){
        this.page = this.pages;
        this.isLastDisabled = true;

        nextPage({pageNumber : this.page})
            .then(result => {
                this.firstName = result.accLst;
                this.total = result.totalRecords;
                this.page = result.currentPage;
                this.pages = Math.ceil(this.total / 5);
                
                this.isNextDisabled =true;
                this.isFirstDisabled = false;
                this.isPreviousDisabled = false;

                if(this.page === 1){
                    this.isPreviousDisabled = true;
                }
                if(this.page === this.pages ){
                    this.isNextDisabled = true;
                }
            })
            .catch(error => {
                console.log('error in last : ', JSON.stringify(error));
            })
    }

    getPageNumber(event){        
        this.textboxPageNumber = event.target.value;

        if(this.textboxPageNumber > this.pages){
            this.page = this.pages;            
        }
        else if(this.textboxPageNumber < 0){
            this.page = 1;            
        }
        else{
            this.page = this.textboxPageNumber;
        }

        nextPage({pageNumber : this.page})
            .then(result => {
                this.firstName = result.accLst;
                this.total = result.totalRecords;
                this.page = result.currentPage;
                this.pages = Math.ceil(this.total / 5);

                if(this.page >= this.pages){
                    this.isNextDisabled = true;
                    this.isLastDisabled = true;
                }
                else{
                    this.isNextDisabled = false;
                    this.isLastDisabled = false;
                }

                if(this.page === 1){
                    this.isPreviousDisabled = true;
                    this.isFirstDisabled = true;
                }
                else{
                    this.isPreviousDisabled = false;
                    this.isFirstDisabled = false;
                }
                
            })
    }

    handleCustomEvent(event){
        const textval = event.detail;
        console.log('textVal : ', textval);
        this.textval = textval;
    }
}