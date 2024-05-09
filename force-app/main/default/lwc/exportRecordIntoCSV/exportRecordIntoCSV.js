/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2024-04-17 11:40:02
 * @modify date 2024-04-22 11:11:59
 * @desc [It will download CSV File Based on Listview Filter for that object]
 */

import { LightningElement, track, wire } from 'lwc';
import fetchContactsBasedOnListView from '@salesforce/apex/ExportToExcelController.fetchContactsBasedOnListView';
import getListViewBasedOnObjectName from '@salesforce/apex/ExportToExcelController.getListViewBasedOnObjectName';
import ContactListURL from '@salesforce/label/c.ContactListURL';
import LightningAlert from 'lightning/alert';
export default class ExportRecordIntoCSV extends LightningElement {
    value = '--None--';
    @track error;
    @track data;
    TypeOptions = [];
    ContactListURL = ContactListURL;

    connectedCallback() {
        debugger;
        setTimeout(() => {
            getListViewBasedOnObjectName({ objectApiName: 'Contact' })
                .then(data => {
                    var listview = data;
                    var tempList = [];
                    for (var i = 0; i < listview.length; i++) {
                        tempList.push({ label: listview[i], value: listview[i] });
                    }
                    this.TypeOptions = tempList;
                })
        }, 300);
    }

    downloadCSVFileRecordData() {
        debugger;
        fetchContactsBasedOnListView({ listvieFilter: this.value, objectApiName: 'Contact' })
            .then(data => {
                if (data !=null) {
                    this.data = data;
                    this.downloadCSVFile();
                } else {
                    this.handleAlert();
                } 
            })
    }

    HandleChange(event) {
        debugger;
        this.value = event.detail.value;
    }

   // showErrorToast() {
        debugger;
        async handleAlert() {
            await LightningAlert.open({
                message: '𝐍𝐨 𝐑𝐞𝐜𝐨𝐫𝐝𝐬 𝐅𝐨𝐮𝐧𝐝 !',
                theme: 'warning', // more would be success, info, warning
                label: 'WARNING!', // this is the header text
            });
            //Alert has been closed
        }
        
   // }

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
        downloadElement.download = this.value + ' Contact Data.csv';
        document.body.appendChild(downloadElement);
        downloadElement.click();
        window.location.href = this.ContactListURL;
    }
}