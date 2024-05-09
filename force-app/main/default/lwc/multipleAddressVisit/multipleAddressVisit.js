import { LightningElement, wire, api, track } from 'lwc';
import getAllAddresses from "@salesforce/apex/MultipleAddressContactController.getAllCustomerAddress";
import getUpdateOpportunityAccountAddresss from "@salesforce/apex/MultipleAddressContactController.UpdateOpportunityAccountAddresss";
import getUpdateVisitAccountAddresss from "@salesforce/apex/MultipleAddressContactController.UpdateVisitAccountAddresss";

import getVisitDetails from "@salesforce/apex/MultipleAddressContactController.getVisitDetails";

import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';

export default class MultipleAddressVisit extends LightningElement {
 @api recordId;
 @api contactId;
    selectedAddressIndex = -1;
    selectedBilAddressIndex = -1;
    @track ship_addresses = [];
    @track bill_addresses = [];
    @track ShippingAddressId;
    @track BillingAddressId;
    error;
    @track checkedShipAdd;
    @track checkedBillAdd
    @track accRecord;
    @track nextBtn = true;
    llcUser = false;
    
    connectedCallback(){
        setTimeout(() => {
            this.recordId = this.recordId;
            this.getVisitDetailsMethod();
        }, 300);
    }

getVisitDetailsMethod(){
    debugger;
    getVisitDetails({recordId : this.recordId})
    .then(result =>{
       if(result !=null){
         if(result.Contact_Person__c !=null){
             this.contactId = result.Contact_Person__c;
             this.getRecordDetails();
         }
       }
    })
    .catch(error =>{
        console.log('Error getVisitDetails method === >'+error);
    })
}


    getRecordDetails(){
        debugger;
        getAllAddresses({custId : this.contactId}).then(data => {
            if(data){
                debugger;
                let clonedData = JSON.parse(JSON.stringify(data));
                this.accRecord = clonedData.account;
                this.ship_addresses = clonedData.customer_ship_addresses;
                this.bill_addresses = clonedData.customer_bill_addresses;
                this.selectedAddressIndex = clonedData.ship_selected_index != undefined ? clonedData.ship_selected_index : -1;
                this.selectedBilAddressIndex = clonedData.bill_selected_index != undefined ? clonedData.bill_selected_index : -1;
                console.log('RecordId', this.recordId);
                console.log('Data',clonedData);
                if(this.ship_addresses && this.bill_addresses ){
                    this.nextBtn = false;
                }else{
                    this.nextBtn = true;
                }
            }
       })
    }

    onAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;
         this.checkedShipAdd = event.target.checked;
         if(this.checkedBillAdd==undefined){
              this.checkedBillAdd=true;
          }   
        if(addressId && selectedIndex ) {
            if(this.selectedAddressIndex !== -1)
                this.ship_addresses[this.selectedAddressIndex].checked = false;
            this.ship_addresses[selectedIndex].checked = true;
            this.selectedAddressIndex = selectedIndex;
        }
         if(this.checkedShipAdd &&  this.checkedBillAdd ){
                this.nextBtn = false;
        }else{
              this.nextBtn = true;
        }
    }

    onBillAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;
         this.checkedBillAdd = event.target.checked;   
          if(this.checkedShipAdd==undefined){
              this.checkedShipAdd=true;
          }
        if(addressId && selectedIndex ) {
            if(this.selectedBilAddressIndex !== -1)
                this.bill_addresses[this.selectedBilAddressIndex].checked = false;
            this.bill_addresses[selectedIndex].checked = true;
            this.selectedBilAddressIndex = selectedIndex;
        }
         if(this.checkedShipAdd &&  this.checkedBillAdd ){
                this.nextBtn = false;
        }else{
              this.nextBtn = true;
        }
    }

    handleNavigate() {
        debugger;
        let index = this.ship_addresses.findIndex((item) => {
            return item.checked === true;
        });

        let billingIndex = this.bill_addresses.findIndex((item) => {
            return item.checked === true;
        });
        if(index === -1 || billingIndex === -1) {
            const evt = new ShowToastEvent({
                title: "No Selection",
                message: "Please select Shipping and Billing address in-order to proceed.",
                variant: "Warning",
            });
            this.dispatchEvent(evt);
            return;
        }

        let selectedAddress = this.ship_addresses[index];
        let shippaddressId = selectedAddress.id;
        if(shippaddressId !=undefined){
            this.ShippingAddressId = shippaddressId;
        }
        let accShipAddress = false;

        let selectedBillingAddress = this.bill_addresses[billingIndex];
        let billAddressId = selectedBillingAddress.id;

        if(billAddressId !=undefined){
            this.BillingAddressId = billAddressId;
        }

        let accountBillAddress = false;
        
        if(selectedAddress.id === 'Shipping') {
            accShipAddress = true;
        }
        
        if(selectedBillingAddress.id === 'Billing') {
            accountBillAddress = true;
        }
     this.updateOpportunityAccAddress();
    }    

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
   
     updateOpportunityAccAddress(){
         debugger;
    getUpdateVisitAccountAddresss({oppId : this.recordId,shippindId:this.ShippingAddressId,billingId:this.BillingAddressId})
       .then(result =>{
            const event = new ShowToastEvent({
            title: 'SUCCESS',
            message: 'Address Updated Successfully !',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        //    var BaseURL = BaseURLOpportunity;
        //    location.replace(BaseURL + this.recordId);
           window.location.href = BaseURLOpportunity+this.recordId+'/view';
       // window.location.reload();
       })
       .catch(error =>{
        this.error = error;
        const evt = new ShowToastEvent({
            title: 'ERROR',
            message: this.error,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
       })
     }
   
    
}