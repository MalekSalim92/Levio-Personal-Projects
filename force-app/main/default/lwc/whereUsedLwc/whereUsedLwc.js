import { LightningElement,wire } from 'lwc';
import fetchMetadataItems from '@salesforce/apex/WhereUsedMetadataService.fetchMetadataItems';


export default class WhereUsedLwc extends LightningElement {
    selectedMetadata = 'ApexClass';
    metadataItems;
      metadataOptions = [
        { label: "Custom Object" , value : "CustomObject" , icon: "utility:open_folder"},
        { label: "Custom Field" , value : "CustomField" , icon: "utility:file"},
        { label: "Flow" , value : "FlowDefinition" , icon: "utility:flow"},
        { label: "Apex Class" , value : "ApexClass" , icon: "utility:apex"},
        { label: "Apex Trigger" , value : "ApexTrigger" , icon: "utility:connected_apps"},
        { label: "LWC" , value : "LightningComponentBundle" , icon: "utility:component_customization"}
        ]
      metadataColumns = [
        { label: "Name" , fieldName : "developerName"}
         ]
    
    connectedCallback(){
        console.log("Component Loaded")
    }
    
        
    handleSelectMetadata(event){
        console.log(this.selectedMetadata);
        this.selectedMetadata = event.detail.name;
        console.log(this.selectedMetadata);

    }

    @wire(fetchMetadataItems , {metadataType : '$selectedMetadata'})
    wiredMetadataItems (data,error){
        if(data){
            console.log(JSON.stringify(data))
            this.metadataItems = data;
        }
        if(error){
            console.error(error)
        }
    }


}