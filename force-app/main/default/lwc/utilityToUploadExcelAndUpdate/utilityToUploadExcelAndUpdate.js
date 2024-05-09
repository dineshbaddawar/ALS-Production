import { LightningElement, api, wire, track } from 'lwc';
import CreateSampleUpdateRecords from '@salesforce/apex/UtilityToUploadExcelAndUpdateController.CreateSampleUpdateRecords';
import getSample_update_mdt from '@salesforce/apex/UtilityToUploadExcelAndUpdateController.getSample_update_mdt';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UtilityToUploadExcelAndUpdate extends LightningElement {
    file;
    quotNames;
    @track sample_update_field;
    @track ExcelFormat = [];

    connectedCallback() {
        debugger
        getSample_update_mdt()
            .then(result => {
                if (result) {
                    console.log('result', result);
                    this.sample_update_field = result;
                    let excelformat = this.sample_update_field.map((item) => { return item.Field_Label__c });
                    console.log('excelformat', JSON.stringify(excelformat));
                    let objstr = {};
                    if (excelformat.length > 0) {
                        excelformat.forEach(currentItem => {
                            if (currentItem) {
                                objstr[currentItem] = '';
                            }
                        });
                        this.ExcelFormat.push(objstr);
                        console.log('objstr', JSON.stringify(objstr));
                    }
                    console.log('ExcelFormat', JSON.stringify(this.ExcelFormat));
                }
            })
            .catch(error => {
                console.log('error', error);
            })
    }

    handleInputChange(event) {
        debugger;
        if (event.target.files.length > 0 && event.target.files[0].size > 0) {
            this.file = event.target.files[0];
            this.read(this.file);
        };
    }

    async read(file) {
        debugger;
        try {
            const result = await this.load(file);
            this.parse(result);
        } catch (e) {
            this.error = e;
            console.error('error=>', e);
            // "26/03/2024  12:30:00 PM"
        }
    }

    async load(file) {
        debugger;
        return new Promise((resolve, reject) => {
            const reader = new FileReader();

            reader.onload = () => {
                resolve(reader.result);
            };
            reader.onerror = () => {
                reject(reader.error);
            };
            reader.readAsText(file);
        });
    }

    @track Csvdata = [];
    

    parse(csv) {
        const lines = csv.split(/\r\n|\n/);
        const headers = lines[0].split(',');
        const data = [];

        lines.forEach((line, i) => {
            if (i === 0) return;
            if (line == '' || line.trim() === '' || line == '"\\""' || line == '\"') return;

            const obj = {};
            const currentline = line.split(',');

            for (let j = 0; j < headers.length; j++) {
                const fieldName = headers[j];

                let field_api_name = this.sample_update_field.find((item) => item.Field_Label__c == fieldName).Field_API_Name__c;
                let field_data_type = this.sample_update_field.find((item) => item.Field_Label__c == fieldName).Field_Data_Type__c;
                let filtered_str = currentline[j].replace('\"', '');

                if (filtered_str != null && filtered_str != undefined && filtered_str != '') {
                    if (field_data_type == 'Date/Time') {
                        var dateString = filtered_str;
                        if (dateString.match(/(AM|PM)/)) { 
                            dateString =  dateString.replace(" PM", "");
                        }

                        var format1RegexHyphen = /^\d{2}-\d{2}-\d{4} \d{2}:\d{2}$/;
                        var format2RegexSlash = /^\d{1,2}\/\d{1,2}\/\d{4} \d{2}:\d{2}$/;

                        if (format1RegexHyphen.test(dateString)) {
                            console.log('Format 1 format1RegexHyphen');

                            const [datePart, timePart] = dateString.split(" ");
                            const [day, month, year] = datePart.split("-");
                            const [time, period] = timePart.split(" ");
                            let [hour, minute, second] = time.split(":");
                            // if (period === "PM") {
                            //     hour = parseInt(hour) + 12; // Convert to 24-hour format if PM
                            // }
                            var dateString;
                            if (second != undefined) {
                                dateString = `${year}-${month}-${day}T${hour}:${minute}:${second}.000Z`;
                            } else {
                                dateString = `${year}-${month}-${day}T${hour}:${minute}:00.000Z`;
                            }
                            const dateToString = new Date(dateString);
                            obj[field_api_name] = dateToString.toISOString();
                        } else if (format2RegexSlash.test(dateString)) {
                            console.log('Format 2 format2RegexSlash');
                           // new Date(filtered_str).toISOString();
                            obj[field_api_name] = new Date(filtered_str).toISOString();

                         }

                                               

                        } else {
                            obj[field_api_name] = filtered_str;
                        }
                }
            }
            if(Object.keys(obj).length != 0){
                   data.push(obj);
            }
            
        });

        console.log('dataUpdated=', JSON.stringify(data));

        this.Csvdata = data.filter((item)=>item);
        if (this.Csvdata.length > 0) {
            this.handleSubmit(this.Csvdata);
        }
    }




    handleSubmit(ArrayList) {
        console.log('data in Csvdata after onclick=', JSON.stringify(this.Csvdata));

        debugger;
        CreateSampleUpdateRecords({ sampleUpdateList: ArrayList })
            .then(result => {
                if (result == 'SUCCESS') {

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Sample Update Records Created successfully..',
                            variant: 'success',
                        }),
                    );
                }
                else {

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'error',
                            message: result,
                            variant: 'error',
                        }),
                    );
                }
            })
            .catch(error => {
                window.alert(error);
                console.log('error in Comp=', error);

            })
    }

    ligtningAlertOnUpload() {
        LightningAlert.open({
            message: 'This is the alert message.',
            theme: 'Success', // a red theme intended for error states
            label: 'Uploading!', // this is the header text
        });
    }

    //DownLoad Data IN CSV Foramt

    HandleDownLoad() {
        debugger;
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.ExcelFormat.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
                console.log('rowData=' + rowData);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        console.log('rowData in array Form=' + rowData);

        // splitting using ','
        csvString += rowData.join(',');
        console.log('csvString with JoinMethod=' + csvString);

        csvString += rowEnd;
        console.log('csvString with rowEndVariable=' + csvString);

        // main for loop to get the data based on key value
        for (let i = 0; i < this.ExcelFormat.length; i++) {
            let colValue = 0;

            // validating keys in data
            for (let key in rowData) {
                if (rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    console.log('rowKey Values=' + rowKey);
                    // add , after every value except the first.
                    if (colValue > 0) {
                        csvString += ',';
                        console.log('csvString with ,=' + csvString);
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.ExcelFormat[i][rowKey] === undefined ? '' : this.ExcelFormat[i][rowKey];
                    csvString += '"' + value + '"';
                    console.log('csvString After adding Value=' + csvString);
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Sample Update.csv';
        // below statement is required if you are using firefox browser
        // document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click();
    }
}