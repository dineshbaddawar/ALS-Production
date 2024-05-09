import { LightningElement, track, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getCurrenyCode from "@salesforce/apex/QuoteScreenController.getCurrenyCode";
export default class SelectProductInQuote extends LightningElement {
    @track isModalOpen = true;
    @track isPriceBook;
    @track value;
    @track error;
    @track isProduct = false;
    @api recordId;
    // get options() {
    //     return [
    //         { label: 'None', value: 'None' },
    //         { label: 'Standard', value: 'Standard' },
            
    //     ];
    // }

    connectedCallback() {
        debugger;
        setTimeout(() => {
            this.recordId = this.recordId;
            this.currentQuoteCurrency();
           // alert('selectProductInQuote == >' + this);
        }, 300);
    }

    currentQuoteCurrency(){
        debugger;
        getCurrenyCode({recId:this.recordId}).then((result) => {
            if(result){
                this.value = result;
                this.error = undefined;
            }
        }).catch((err) => {
            this.error=err;
            this.opportunityName=undefined;
        });
    }

    handleChange(event){
        debugger;
        this.value = event.target.value;
    }
    handleClick() {
        this.isModalOpen = false;
        this.isProduct = true;
    }

    modalCloseHandler(){
        debugger;
        this.closeAction();
    }

    closeGrandChild(){
        this.closeAction();
    }

    closeAction(){
        debugger;
  this.dispatchEvent(new CloseActionScreenEvent());
}
}