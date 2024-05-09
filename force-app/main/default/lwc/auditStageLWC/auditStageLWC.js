import { LightningElement, api } from 'lwc';
import updateLeadStageToAudit from '@salesforce/apex/UtilityClassForEmailMethod.updateLeadStageToAudit';
import fetchStakeHolderDetails from '@salesforce/apex/LeadStageUpdateController.fetchStakeHolderDetails';
import sendAduitDetailsToStackHolderEmail from '@salesforce/apex/UtilityClassForEmailMethod.sendAduitDetailsToStackHolderEmail';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/refresh';
import LeadBaseURL from '@salesforce/label/c.LeadBaseURL';

export default class RecordEditFormEditExampleLWC extends LightningElement {
    isLoaded = false;
    @api recordId;

    handleSubmit(event) {
        this.isLoaded = true;
        console.log('onsubmit event recordEditForm' + event.detail.fields);
    }
    connectedCallback() {
        debugger;
       setTimeout(()=>{
        this.recordId = this.recordId;
       },300);
    }    

    handleSuccess(event) {
        debugger;
        console.log('onsuccess event recordEditForm', event.detail.id);
        if (event.detail.id != undefined && event.detail.id !=null) {
            this.recordId = event.detail.id;
        }
        sendAduitDetailsToStackHolderEmail({ recordId: event.detail.id })
            .then(result => {
                if (result == 'SUCCESS') {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'SUCCESS',
                            message: 'Lead Udated Successfully !',
                            variant: 'success',
                        })
                    );
                    this.dispatchEvent(new CloseActionScreenEvent());
                    window.location.href = LeadBaseURL+this.recordId+'/view'; 
                }
                if (result == 'FAIL') {
                    this.calllUpdateLeadStageTaskCreateMethod();
                }
            })
    }
    calllUpdateLeadStageTaskCreateMethod() {
        debugger;
        alert('Updated Lead recordId === >'+this.recordId);
        updateLeadStageToAudit({ recordId: this.recordId })
            .then(result => {
                if (result == 'SUCCESS') {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'SUCCESS',
                            message: 'Lead Udated Successfully !',
                            variant: 'success',
                        })
                    );
                    this.dispatchEvent(new CloseActionScreenEvent());
                    window.location.href = LeadBaseURL+this.recordId+'/view'; 
                }else{
                     this.dispatchEvent(new CloseActionScreenEvent());
                }
            })
            .catch(error => {
               alert('Something went wrong ')
            })
    }
}