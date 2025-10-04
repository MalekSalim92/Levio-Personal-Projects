public with sharing class WhereUsedMetadataService {
        
    @AuraEnabled (cacheable=true)
    public static List<MetadataItem> fetchMetadataItems(String metadataType) {
        List<MetadataItem> metadataItems = new List<MetadataItem>();

        try {
           
            if (!ALLOWED_METADATA_TYPES.contains(metadataType)) throw new AuraHandledException('Invalid metadata type: ' + metadataType);
            if (metadataType.startsWith('Apex')) return fetchApex(metadataType);
            else return metadataItems = fetchMetadataTooling(metadataType);
        
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching metadata: ' + e.getMessage());
        }

    }


    // Fetch APEX  
    private static List<MetadataItem> fetchApex(String metadataType) {
    
        List<MetadataItem> items = new List<MetadataItem>();
        List<SObject> apexItems = MetadataSelector.selectApexMetadata(metadataType);
        for (SObject sObj : apexItems) {
            items.add(new MetadataItem(
                (String)sObj.get('Id'),
                (String)sObj.get('Name')
            ));
        }
        
        return items;
    }
 

    //Fetch Metadata with tooling API 

    private static List<MetadataItem> fetchMetadataTooling(String metadataType) {
        List<MetadataItem> metadataList = new List<MetadataItem>();
       
        List<Object> records = MetadataSelector.selectToolingApi(metadataType);
        for (Object o : records) {
            Map<String, Object> r = (Map<String, Object>) o;
            metadataList.add(new MetadataItem(
                (String) r.get('Id'),
                (String) r.get('DeveloperName')
            ));
         
    }
    return metadataList;

}

@AuraEnabled (cacheable=true)
public static List<metadataDependecy> getDependencies(String metadataType){
    List<metadataDependecy> dependencyList = new List<metadataDependecy>();

    for(String metadata : ALLOWED_METADATA_TYPES){

        List<Object> records = MetadataSelector.selectDependecies(metadata);
      for (Object o : records) {
          Map<String, Object> r = (Map<String, Object>) o;
          dependencyList.add(new metadataDependecy(
              (String) r.get('MetadataComponentId'),
              (String) r.get('MetadataComponentName'),
              (String) r.get('MetadataComponentType'),
              (String) r.get('RefMetadataComponentId'),
              (String) r.get('RefMetadataComponentName'),
              (String) r.get('RefMetadataComponentType')
          ));
       
  }
    }

    return dependencyList;
                      
                      }
                      

 
 // Wrapper class for metadata dependencies
 public class metadataDependecy{
    @AuraEnabled public String id { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String type { get; set; }
    @AuraEnabled public String refId { get; set; }
    @AuraEnabled public String refName { get; set; }
    @AuraEnabled public String refType { get; set; }
     
    public metadataDependecy(String id, String name, String type, String refId, String refName, String refType) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.refId = refId;
        this.refName = refName;
        this.refType = refType;
     }
}


 // Wrapper class for metadata items
 public class MetadataItem {
    @AuraEnabled public String id { get; set; }
    @AuraEnabled public String developerName { get; set; }
     
    public MetadataItem(String id, String developerName) {
        this.id = id;
        this.developerName = developerName;
     }
}




private static final Set<String> ALLOWED_METADATA_TYPES = new Set<String>{
    'ApexClass',
    'ApexTrigger',
    'CustomObject',
    'CustomField',
    'FlowDefinition',
    'LightningComponentBundle'
};

}
