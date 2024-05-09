import { LightningElement, api } from 'lwc';

export default class Recordpickercontact extends LightningElement {
    @api AccountIdForLWC;
    filter = {};
    matchingInfo = {
        primaryField: { fieldPath: "Name" },
        additionalFields: [{ fieldPath: "Email" }],
    };
    displayInfo = {
        additionalFields: ["Email", "Title"],
    };

    connectedCallback() {
        if (this.AccountIdForLWC) {
            this.filter = {
                criteria: [{
                    fieldPath: 'AccountId',
                    operator: 'eq',
                    value: this.AccountIdForLWC,
                }],
            };
        }
    }

    handleChange(event) {
        const value = event.detail.recordId;
        const auraEvent = new CustomEvent('sendidtoaura', {
            detail: { value }
        });
        this.dispatchEvent(auraEvent);
    }
}