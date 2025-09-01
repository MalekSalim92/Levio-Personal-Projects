public with sharing class WhereUsedMetadataService {
        
    @AuraEnabled (cacheable=true)
    public static List<MetadataItem> fetchMetadataItems(String metadataType) {
        List<MetadataItem> metadataItems = new List<MetadataItem>();
        System.debug('metadataType' + metadataType);
        try {
            if (!ALLOWED_METADATA_TYPES.contains(metadataType)) {
                throw new AuraHandledException('Invalid metadata type: ' + metadataType);
            }

            if (metadataType.startsWith('Apex')) {
                metadataItems = fetchApex(metadataType);
            }
            else{
                metadataItems = fetchMetadataTooling(metadataType);
            }

        
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching metadata: ' + e.getMessage());
        }

        return metadataItems;
    }


    // Fetch APEX  
    private static List<MetadataItem> fetchApex(String metadataType) {
       
    
        List<MetadataItem> items = new List<MetadataItem>();
        system.debug('classes here');
        String query = 'SELECT Id, Name FROM ' + metadataType + ' ORDER BY Name';
        List<SObject> apexItems = Database.query(query);
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
        System.debug('fetchMetadataTooling');

        // Build REST endpoint for Tooling API query,
        String toolingQuery = 'SELECT Id, DeveloperName FROM ' + metadataType ;
       
        List<Object> records = toolingApiCall(toolingQuery);
        for (Object o : records) {
            Map<String, Object> r = (Map<String, Object>) o;
            metadataList.add(new MetadataItem(
                (String) r.get('Id'),
                (String) r.get('DeveloperName')
            ));
         
    }
    return metadataList;

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

    // tooling api 

    private static List<Object> toolingApiCall(String toolingQuery) {
        List<Object> metadataList = new List<Object>();
 
        // Build REST endpoint for Tooling API query,
        // Prepare HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:toolingApi/services/data/v58.0/tooling/query/?q=' + EncodingUtil.urlEncode(toolingQuery,'UTF-8'));
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        System.debug('req ' + req);

        HttpResponse res = http.send(req);
        System.debug('res ' + res);

        if (res.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            metadataList = (List<Object>) resultMap.get('records');
 
        } else {
            throw new AuraHandledException('Tooling API call failed: ' + res.getStatus() + ' ' + res.getBody());
        }

        return metadataList;
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
// SELECT MetadataComponentId, MetadataComponentName, MetadataComponentType,
//        RefMetadataComponentId, RefMetadataComponentName, RefMetadataComponentType
// FROM MetadataComponentDependency
// WHERE MetadataComponentType = 'LightningComponentBundle'
