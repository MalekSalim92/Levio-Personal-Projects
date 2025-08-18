import { LightningElement,wire,api } from 'lwc';
import getAllSalesforceObjects from '@salesforce/apex/BulkRecordUpdaterController.getAllSalesforceObjects';
import getAllRecords from '@salesforce/apex/BulkRecordUpdaterController.getAllRecords';
import getFieldsEditable from '@salesforce/apex/BulkRecordUpdaterController.getFieldsEditable';

export default class BulkRecordUpdater extends LightningElement {

    // ----------------------
    // Properties
    // ----------------------

    salesforceObjectOptions = []
    objectFieldsOptions = []
    records = []
    isLoading = true
    min = 1
    max = 10
    selectedObject
    selectedFields
    error 


    // ----------------------
    // Getters
    // ----------------------

    get isUpdateDisabled(){
        return !this.selectedObject || !this.selectedFields
    }

    get columns(){
        if(!this.selectedFields) return []
        return this.selectedFields.map(field =>({
            label : field,
            fieldName : field,
            editable : true

        }))
    }

    // ----------------------
    // Wires
    // ----------------------

    @wire(getAllSalesforceObjects)
    wiredObject({data,error}){
        if(data){
            this.salesforceObjectOptions = data.map(obj => ({
                label: obj.Label,
                value: obj.QualifiedApiName
            }))
        }
        if(error){
            console.error(error)
        }
        this.isLoading = false
     }


     @wire(getFieldsEditable, { objName: '$selectedObject' })
     wiredFields({ data, error }) {
        this.isLoading = true

        // console.log(JSON.stringify(data));
        console.log('DATE : ',data);
         if (data) {
            console.log('Here')
             this.objectFieldsOptions = data; // Already in correct format
             console.log(this.objectFieldsOptions);
         }
         if (error) {
            console.log('There')

             console.error(error);
         }
         this.isLoading = false

     }

    // ----------------------
    // Apex Calls
    // ----------------------

    async fetchRecords(objName,fields){
        console.log('objName ',objName)
        console.log('fields ',fields)
        if(!fields || !objName) return;
        try{
            this.records = await getAllRecords({objName :objName, fields: JSON.stringify(fields)});  
        }
        catch{

        }
    }


    // ----------------------
    // Event Handlers
    // ----------------------
     

    handleChangeObject(event){
        this.isLoading = true
        this.selectedObject = event.detail.value
        console.log(this.selectedObject)
        //this.fetchObjectFields()
    }    

    handleChangeFields(event){
        this.selectedFields = event.detail.value
        console.log(this.selectedFields)
        this.fetchRecords(this.selectedObject,this.selectedFields)
    }    
 
 
    handleClear(){
        this.selectedObject = null;
        this.selectedFields = null
    }
}