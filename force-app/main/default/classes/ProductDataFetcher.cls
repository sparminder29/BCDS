public with sharing class ProductDataFetcher {

    public class Request {
        @InvocableVariable
        public String User_Input;
    }

    public class Response {
        @InvocableVariable
        public String Prompt; // Output variable to store the formatted data
    }

    public class ProductNameWrapper {
        @InvocableVariable(label='Product Name')
        public String productName;

        public ProductNameWrapper(String name) {
            this.productName = name;
        }
    }

    @InvocableMethod(label='Fetch Active Product Names' description='Fetches names of active products')
    public static List<Response> getAllProductNames(List<Request> requests) {
        List<ProductNameWrapper> names = new List<ProductNameWrapper>();
        for (Product2 p : [SELECT Name FROM Product2 WHERE IsActive = true]) {
            names.add(new ProductNameWrapper(p.Name.trim()));
        }

        // Build JSON-like output
        String prompt = '[';
        for (Integer i = 0; i < names.size(); i++) {
            prompt += '""' + names[i].productName + '""';
            if (i < names.size() - 1) {
                prompt += ', ';
            }
        }
        prompt += ']';

        // Prepare response
        List<Response> responseList = new List<Response>();
        Response res = new Response();
        res.Prompt = prompt;
        responseList.add(res);
        return responseList;
    }
}