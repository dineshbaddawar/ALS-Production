import { LightningElement,track } from 'lwc';
import fetchOpportunitiesBasedOnListView from '@salesforce/apex/ExportToExcelController.fetchOpportunitiesBasedOnListView';
import getListViewBasedOnObjectName from '@salesforce/apex/ExportToExcelController.getListViewBasedOnObjectName';
import OpportunityListURL from '@salesforce/label/c.OpportunityListURL';
import LightningAlert from 'lightning/alert';
export default class ExportOpportunityRecordIntoCSV extends LightningElement {
    value = '--None--';
    @track error;
    @track data;
    TypeOptions = [];
    OpportunityListURL = OpportunityListURL;

    connectedCallback() {
        debugger;
        setTimeout(() => {
            getListViewBasedOnObjectName({ objectApiName: 'Opportunity1__c' })
                .then(data => {
                    var listview = data;
                    var tempList = [];
                    for (var i = 0; i < listview.length; i++) {
                        tempList.push({ label: listview[i], value: listview[i] });
                    }
                    tempList.push({label : 'Recently Viewed', value: 'Recently Viewed'});
                    this.TypeOptions = tempList;

                    // tempList.push({label : 'Closed won Opp', value: 'Closed won Opp'});
                    // this.TypeOptions = tempList;
                })
        }, 300);
    }

    downloadCSVFileRecordData() {
        debugger;
        fetchOpportunitiesBasedOnListView({ listvieFilter: this.value, objectApiName: 'Opportunity1__c' })
            .then(data => {
                if (data) {
                    this.data = data;
                    this.downloadCSVFile();
                }  else {
                    this.handleAlert();
                } 
            })
    }

    HandleChange(event) {
        debugger;
        this.value = event.detail.value;
    }

    async handleAlert() {
        debugger;
            await LightningAlert.open({
                message: '𝐍𝐨 𝐑𝐞𝐜𝐨𝐫𝐝𝐬 𝐅𝐨𝐮𝐧𝐝 !',
                theme: 'warning',
                label: 'WARNING!', 
            });
            
        }

    downloadCSVFile() {
        let rowEnd = '\n';
        let csvString = '';
        let rowData = new Set();

        this.data.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        rowData = Array.from(rowData);

        csvString += rowData.join(',');
        csvString += rowEnd;

        for (let i = 0; i < this.data.length; i++) {
            let colValue = 0;

            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    let rowKey = rowData[key];
                    if (colValue > 0) {
                        csvString += ',';
                    }
                    let value = this.data[i][rowKey] === undefined ? '' : this.data[i][rowKey];
                    csvString += '"' + value + '"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        let downloadElement = document.createElement('a');

        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        downloadElement.download = this.value + ' Opportunity Data.csv';
        document.body.appendChild(downloadElement);
        downloadElement.click();
        window.location.href = this.OpportunityListURL;
    }

}