/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2024-04-03 10:02:25
 * @modify date 2024-04-03 11:46:35
 * @desc [Used Send Mom Email on Visit Record Page]
 */

import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import createMomActivityLog  from '@salesforce/apex/TodayTaskAuraController.createMomActivityLog';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import BaseURLOpportunity from '@salesforce/label/c.BaseURLOpportunity';
export default class SendMomVisit extends LightningElement {
     
     @api recordId;
     @track selectedUserId;
     subject;
     description;
     stackholderemail;
     mobileRedirect;

     isMobileDevice(){
          const userAgent = window.navigator.userAgent;
          return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(userAgent);
     }
     
     handleLwcEvent(event) {
          debugger;
           this.selectedUserId = event.detail.value;
           console.log('Selected User ID:', this.selectedUserId);
     }
     connectedCallback() {
          debugger;
          if(this.isMobileDevice()){
               // alert('Inside Mobile App')
               this.mobileRedirect = true;
          } else {
             //  alert('Inside Desktop')
             }
          setTimeout(() => {
               this.recordId = this.recordId;     
          }, 3000);
      }

     closeModal() {
          debugger;
          this.dispatchEvent(new CloseActionScreenEvent());
     }
     handleChange(event) {
          debugger;
          const value = event.target.value;
          const name = event.target.name;
          if (name === 'subject') {
               this.subject = value;
          }
          if (name === 'email') {
               this.stackholderemail = value;
          }
          if (name === 'description') {
               this.description = value;
          }
     }
     SendMomActivity() {
          debugger;
          createMomActivityLog({
               description: this.description,
               visitId: this.recordId,
               subject: this.subject,
               salesUserId: this.selectedUserId,
               stackholderEmail : this.stackholderemail
          })
               .then(result => {
                    if (result == 'SUCCESS') {
                         this.showToast();
               }
          })
     }

     showToast() {
          const event = new ShowToastEvent({
              title: 'SUCCESS',
              message: 'MOM Sent Successfully !',
              variant: 'success',
              mode: 'dismissable'
          });
          this.dispatchEvent(event);
          if (this.mobileRedirect) {
              // alert('Inside Mobile App')
               window.location.href = BaseURLOpportunity+this.recordId+'/view';
          } else {
               this.closeModal();
          }
     }
     
}