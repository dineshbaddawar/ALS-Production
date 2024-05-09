import { LightningElement ,api } from 'lwc';
export default class Userlookup extends LightningElement {
    id;
    @api auraUserId;
    matchingInfo = {
        primaryField: { fieldPath: "Name" },
        additionalFields: [{ fieldPath: "Email" }],
    };
    displayInfo = {
        additionalFields: ["Email", "Title"],
    };
    handleChange(event) {
        debugger;
        console.log(`Selected record: ${event.detail.recordId}`);
       const value = event.detail.recordId;
        const auraEvent = new CustomEvent('sendidtoaura', {
            detail: {value}
        });
        this.dispatchEvent(auraEvent);
    }
    
    
}