import { LightningElement,wire,track,api } from 'lwc';
import getVisitRelatedContact from "@salesforce/apex/MultipleAddressContactController.getVisitRelatedContact";
import updateVisitContact from "@salesforce/apex/MultipleAddressContactController.updateVisitContact";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LeadBaseURL from '@salesforce/label/c.LeadBaseURL';

let i=0;
export default class AddContavtVisit extends LightningElement {
     @api recordId;
     data;
     error;
     @track items = [];
     selectedContactId;

    @track value = '';
     connectedCallback() {
          debugger;
          setTimeout(() => {
               this.recordId = this.recordId;
             // this.getVisitDetailsMethod();
          }, 300);
     }


     @wire(getVisitRelatedContact, { recordId: '$recordId'})
    wiredContacts({ error, data }) {
        if (data) {
            for(i=0; i<data.length; i++) {
                console.log('id=' + data[i].Id);
                this.items = [...this.items ,{value: data[i].Id , label: data[i].Name}];                                   
            }                
             this.error = undefined;
             console.log('list data ==>' + this.items);
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
     }
     get statusOptions() {
          return this.items;
     }
     
     handleChange(event) { 
          debugger;
          this.selectedContactId = event.detail.value;
     }
     closeQuickAction() {
          debugger;
          this.dispatchEvent(new CloseActionScreenEvent());
      }
     HandleSumbit() {
          debugger;
          updateVisitContact({ recordId: this.recordId, contactId: this.selectedContactId })
               .then(result => {
                    if (result != null) {
                         this.dispatchEvent(
                              new ShowToastEvent({
                                  title: 'SUCCESS',
                                  message: 'Contact tagged Successfully !',
                                  variant: 'success',
                              })
                          );
                          this.dispatchEvent(new CloseActionScreenEvent());
                          window.location.href = LeadBaseURL+this.recordId+'/view'; 
               }
          })
      }
     
}