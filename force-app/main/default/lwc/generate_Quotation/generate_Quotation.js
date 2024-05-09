import { LightningElement,api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generateSelectedQuatationPDF from '@salesforce/apex/QuoteHelper.generateSelectedQuatationPDF'; 
import validatePharmaQuote from '@salesforce/apex/QuoteScreenController.validatePharmaQuote'; 
import BanglorePharma from '@salesforce/label/c.ALS_Banglore_Pharma';
import MumbaiPharma from '@salesforce/label/c.ALS_Mumbai_Pharma';
import modal from "@salesforce/resourceUrl/custommodalcss";
import { loadStyle } from "lightning/platformResourceLoader";

export default class generate_Quotation extends LightningElement {
    @api recordId;
    @track isValidatePharma = false;
    @track isValidateENL = false;
    isShowPDFPreview = false;
    isShowButton = false;
    isShowSaveCancelButton = false;
    isShowButtonHide = true;
    isShowMumbaiPharmaPDF = false;
    isShowBanglorePharmaPDF = false;
    value;
    PDFNameToDownload;
    pdfLink;

    get bangloreOptions() {
        debugger;
        return[
            {label:'For Banglore', value: 'Banglore Pharma Template'}
        ]
    }

    get mumbaiOptions() {
        debugger;
        return [
            { label: 'For Mumbai', value: 'Mumbai Pharma Template' }
        ];
    }

    connectedCallback() {
        loadStyle(this, modal);
        setTimeout(() => {
           this.getLabLocation();
        }, 600);
    }

    getLabLocation(){
    validatePharmaQuote({recId:this.recordId}).then((result) => {
        if(result.Lab_Location1__c != undefined && result.Lab_Location1__c == 'Banglore Lab'){
            this.isShowMumbaiPharmaPDF = false;
            this.isShowBanglorePharmaPDF = true;
            this.isShowButton = true;
            this.value = 'Banglore Pharma Template'; 
        } else if(result.Lab_Location1__c != undefined && result.Lab_Location1__c == 'Mumbai Lab'){
            this.isShowMumbaiPharmaPDF = true;
            this.isShowBanglorePharmaPDF = false;
            this.isShowBanglorePharmaPDF = false;
            this.isShowButton = true;
            this.value = 'Mumbai Pharma Template';
        } else {
            this.isShowBanglorePharmaPDF = true;
            this.isShowButton = true;
        }
    }).catch((err) => {
        console.log(err);
    });
}

    getPDFViewData() {
        debugger;
        if (this.value == 'Banglore Pharma Template') {
            this.PDFNameToDownload = this.value;
            this.pdfLink = BanglorePharma+this.recordId;
        }

        if (this.value == 'Mumbai Pharma Template') {
            this.PDFNameToDownload = this.value;
            this.pdfLink = MumbaiPharma+this.recordId;
        }
        console.log('pdfLink',this.pdfLink);
    }

    HandleChangebanglorePharma(event){
        debugger;
        this.value = event.detail.value;
        if (this.value == 'Banglore Pharma Template') {
            this.getPDFViewData();
        }
    }

    HandleChangeMumbaiPharma(event) {
        debugger;
        this.value = event.detail.value;
        if (this.value == 'Mumbai Pharma Template') {
            this.getPDFViewData();
        }
    }

    HandleNextButton() {
        debugger;
        if (this.value == 'Banglore Pharma Template'){
            validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined || result.TAT__c == undefined|| result.ContactId__c == undefined){
                this.isValidatePharma = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidatePharma = false;
                this.isShowPDFPreview = true;
                this.getPDFViewData();
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }
        else if (this.value == 'Mumbai Pharma Template'){
        validatePharmaQuote({recId:this.recordId}).then((result) => {
            if(result.Subject__c == undefined || result.Sample_Quantity__c == undefined || result.TAT__c == undefined|| result.ContactId__c == undefined){
                this.isValidatePharma = true;
                this.isShowButtonHide = false;
            }
            else{
                this.isValidatePharma = false;
                this.isShowPDFPreview = true;
                this.getPDFViewData();
                this.isShowButtonHide = false;
            }
        }).catch((err) => {
            console.log(err);
        });
        }
    }

    HandleSumbit() {
        debugger;
        generateSelectedQuatationPDF({ QuotationName: this.PDFNameToDownload, recordId: this.recordId })
            .then((result) => {
                if (result =='SUCCESS') {
                    const event = new ShowToastEvent({
                        title: 'SUCCESS',
                        message: 'Quotation generated Successfully !',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                    this.closeQuickAction();
                } else {
                    this.showErrorToast();
                    this.closeQuickAction();
                }
            })
            .catch((error) => {
                this.error = error;
           })
    }

    closeQuickAction() {
        debugger;
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Quotation generated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        this.closeQuickAction();
    }

    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'ERROR',
            message: 'Something went wrong !',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        
    }

}