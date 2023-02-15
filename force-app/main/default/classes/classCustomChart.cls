public class classCustomChart {
    static public Map<String, String> initWhereLiterals(){
        Map<String, String> whereClauseLiterals = new Map<String, String>();
        
        whereClauseLiterals.put('Equals','=');
        whereClauseLiterals.put('Not Equals','!=');
        whereClauseLiterals.put('Less Than','<');
        whereClauseLiterals.put('Less Than or Equal','<=');
        whereClauseLiterals.put('Greater Than','>');
        whereClauseLiterals.put('Greater Than or Equal','>=');
        whereClauseLiterals.put('Contains','LIKE');
        whereClauseLiterals.put('In', 'IN');
        whereClauseLiterals.put('Not In', 'NOT IN');
        
        return whereClauseLiterals;
    }
    
    static public Map<String, String> initChartType(){
        Map<String, String> chartType = new Map<String, String>();
        
        chartType.put('Bar Chart','bhg');
        chartType.put('Column Chart','bvg');
        chartType.put('Line Chart','lc');
        chartType.put('Pie Chart','p');
        
        return chartType;
    }
    
    static public String buildSFDCQuery(Custom_Chart__c customChart){
        Map<String, String> whereClauseLiterals = classCustomChart.initWhereLiterals();
        String query = '';
        
        String fieldSyntax = '';
        String whereSyntax = '';
        String fromSyntax = 'FROM '+customChart.Base_Object_API_Name__c;
        String subQuerySyntax = '';
        
        Map<String, List<Custom_Chart_Field__c>> mapCustomChartField = new Map<String, List<Custom_Chart_Field__c>>();
        for(Custom_Chart_Field__c customField: (List<Custom_Chart_Field__c>) customChart.Custom_Chart_Fields__r){
            List<Custom_Chart_Field__c> listCustomChartField = new List<Custom_Chart_Field__c>();
            
            String mapKey;
            if(customField.Custom_Chart_Related_Object__c == null){
            	mapKey = customChart.Base_Object_API_Name__c;
            }else{
            	mapKey = customField.Custom_Chart_Related_Object__r.Related_Object_API_Name__c;
            }
            
            if(mapCustomChartField.containsKey(mapKey))
                listCustomChartField = mapCustomChartField.get(mapKey);
            
            listCustomChartField.add(customField);
            
            mapCustomChartField.put(mapKey,listCustomChartField);
        }
        
        for(String sObjectAPIName : mapCustomChartField.keySet()){
            if(sObjectAPIName != customChart.Base_Object_API_Name__c){
                String subQueryFields = '';
                String subQueryFrom = 'FROM '+sObjectAPIName;
                String subQueryWhere = '';
                
                for(Custom_Chart_Field__c customField: mapCustomChartField.get(sObjectAPIName)){
                    if(customField.Field_Use__c != 'Formula'){
                        if(!subQueryFields.contains(customField.Field_API_Name__c)){
                            subQueryFields += (subQueryFields.length()>0?',':'') +customField.Field_API_Name__c;
                        }
                    }
                    if(customField.Field_Use__c == 'Condition'){
                        String subQueryWhereCondition = '';
                        if(customField.Type__c == 'Contains'){
                            subQueryWhereCondition = '\'%'+ customField.Condition_Value__c +'%\'';
                        }else if(customField.Type__c == 'In' || customField.Type__c == 'Not In'){
                            List<String> listInNotInValues = customField.In_Not_In_Values__c.split(',');
                            for(String inNotIn: listInNotInValues){
                                subQueryWhereCondition += (subQueryWhereCondition.length()>0?',\'':'(\'') + inNotIn+'\'';
                            }
                            subQueryWhereCondition += ')';
                        }else if(customField.Is_Date_Field__c){
                            subQueryWhereCondition = customField.Condition_Value__c;
                        }else{
                            try{
                                Decimal value = Decimal.valueOf(customField.Condition_Value__c);
                                subQueryWhereCondition = customField.Condition_Value__c;
                            }catch(System.Exception e){
                                subQueryWhereCondition = '\''+ customField.Condition_Value__c +'\'';
                            }
                        }
                        
                        subQueryWhere += (subQueryWhere.length()>0?' AND ':' Where ') + customField.Field_API_Name__c +' '+ whereClauseLiterals.get(customField.Type__c) +' '+ subQueryWhereCondition; 
                    }
                }
                if(!subQueryFields.contains('CurrencyIsoCode')) subQueryFields += (subQueryFields.length()>0?',':'')+'CurrencyIsoCode';
                subQuerySyntax += ', (Select ' + subQueryFields + ' ' + subQueryFrom + subQueryWhere+ ')';
                
            }else{
                for(Custom_Chart_Field__c customField: mapCustomChartField.get(sObjectAPIName)){
                    if(customField.Field_Use__c != 'Formula'){
                        if(!fieldSyntax.contains(customField.Field_API_Name__c)){
                            fieldSyntax += (fieldSyntax.length()>0?',':'') +customField.Field_API_Name__c;
                        }
                    }
                    if(customField.Field_Use__c == 'Condition'){
                        String whereCondition = '';
                        if(customField.Type__c == 'Contains'){
                            whereCondition = '\'%'+ customField.Condition_Value__c +'%\'';
                        }else if(customField.Type__c == 'In' || customField.Type__c == 'Not In'){
                            List<String> listInNotInValues = customField.In_Not_In_Values__c.split(',');
                            for(String inNotIn: listInNotInValues){
                                whereCondition += (whereCondition .length()>0?',\'':'(\'') + inNotIn+'\'';
                            }
                            whereCondition += ')';
                        }else if(customField.Is_Date_Field__c){
                            whereCondition = customField.Condition_Value__c;
                        }else{
                            try{
                                Decimal value = Decimal.valueOf(customField.Condition_Value__c);
                                whereCondition = customField.Condition_Value__c;
                            }catch(System.Exception e){
                                whereCondition = '\''+ customField.Condition_Value__c +'\'';
                            }
                        }
                        whereSyntax += (whereSyntax.length()>0?' AND ':' Where ') + customField.Field_API_Name__c +' '+ whereClauseLiterals.get(customField.Type__c) +' '+ whereCondition;
                         
                    }
                }
            }
        }
        if(!fieldSyntax.contains('CurrencyIsoCode')) fieldSyntax += (fieldSyntax.length()>0?',':'')+'CurrencyIsoCode';
        query = 'Select '+(fieldSyntax.length()>0?fieldSyntax:'Id')+subQuerySyntax+' '+fromSyntax+whereSyntax;
        System.debug('Query to run: '+query);
        
        return query;
    }
    
    static public String buildImageURL(Custom_Chart__c customChart){
        
        Map<String, String> chartType = classCustomChart.initChartType();
		Map<String, Map<String, Decimal>> mapRates = classCustomChart.getConversionRate();
        
        String chartURL='';
        
        List<sObject> listSObjectResult = new List<sObject>();
        try{
            listSObjectResult = Database.query(classCustomChart.buildSFDCQuery(customChart));
        }catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The execution of the query failed due to the following reason: '+ e.getMessage()));
            System.debug('The execution of the query failed due to the following reason: '+ e.getMessage());
            return '';
        }
        
        if(listSObjectResult.size()>0){
            
            Map<String, Map<String, String>> mapParameters = new Map<String, Map<String, String>>();
            Map<String, Map<String, Boolean>> mapParametersOnChart = new Map<String, Map<String, Boolean>>();
            
            Decimal minimum = 0;
            Decimal maximum = 100;
            
            Map<String, Decimal> mapMinimum = new Map<String, Decimal>();
            Map<String, Decimal> mapMaximum = new Map<String, Decimal>();
            
            Map<String, String> mapChartField = new Map<String, String>();
            
            Map<String, String> mapColors = new Map<String,String>();
            Map<String, String> mapGroupBy = new Map<String, String>();
            
            String groupByAPIName = '';
            Boolean groupByBaseObject = true;
            String groupByBaseColor = '';
            
            Map<Integer, String> mapIndexCustomField = new Map<Integer, String>();
            
            for(Custom_Chart_Field__c customField: (List<Custom_Chart_Field__c>) customChart.Custom_Chart_Fields__r){
                mapChartField.put(customField.Chart_Field_Number__c,customField.Name);
                if(customField.Display_Order_By__c != null){
            		mapIndexCustomField.put(customField.Display_Order_By__c.intValue(), customField.Chart_Field_Number__c);
            	}
                System.debug('Chart Field #'+customField.Chart_Field_Number__c+' = '+customField.Name);
                if(customField.Field_Use__c == 'Group By'){
                    if(customField.Custom_Chart_Related_Object__c != null){
                        for(sObject result: listSObjectResult){
                            List<sObject> listSObjectRelatedResult = new List<sObject>();
                            try{
                                listSObjectRelatedResult = (sObject[]) result.getSObjects(customField.Custom_Chart_Related_Object__r.Related_Object_API_Name__c);
                            }catch(System.Exception e){
                                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The related list result of the query could not be recovered due to the following error: '+ e.getMessage()));
                                System.debug('The related list result of the query could not be recovered due to the following error: '+ e.getMessage());
                                return '';
                            }
                            if(listSObjectRelatedResult!=null && listSObjectRelatedResult.size()>0){
                                for(sObject related: listSObjectRelatedResult){
                                    try{
                                        mapGroupBy.put(String.valueOf(related.get(customField.Field_API_Name__c)),String.valueOf(related.get(customField.Field_API_Name__c)));
                                    }catch(System.Exception e){
                                        ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The field of the related list could not be recovered due to the following error: '+ e.getMessage()));
                                        System.debug('The field of the related list could not be recovered due to the following error: '+ e.getMessage());
                                        return '';
                                    }
                                    groupByAPIName = customField.Field_API_Name__c;
                                    groupByBaseColor = customField.Display_Color_Hex_Code__c;
                                    groupByBaseObject=false;
                                }
                            }
                        }
                    }else{
                        for(sObject result: listSObjectResult){
                            try{
                                mapGroupBy.put(String.valueOf(result.get(customField.Field_API_Name__c)),String.valueOf(result.get(customField.Field_API_Name__c)));
                            }catch(System.Exception e){
                                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The field could not be recovered due to the following error: '+ e.getMessage()));
                                System.debug('The field could not be recovered due to the following error: '+ e.getMessage());
                                return '';
                            }
                            groupByAPIName = customField.Field_API_Name__c;
                            groupByBaseColor = customField.Display_Color_Hex_Code__c;
                        }
                    }
                }
            }
            if(mapGroupBy.size()==0){ 
            	mapGroupBy.put('','');
            	groupByBaseColor = '0000FF';
            	groupByBaseObject=true;
            }
            
            if(mapGroupBy.size()>0){
                for(String groupBy: mapGroupBy.keySet()){
                    for(Custom_Chart_Field__c customField: (List<Custom_Chart_Field__c>) customChart.Custom_Chart_Fields__r){
                        if(customField.Field_Use__c == 'Summary'){
                            Decimal summaryResult = 0;
                            Decimal countResult = 0;
                            mapColors.put(customField.Chart_Field_Number__c, customField.Display_Color_Hex_Code__c);
                            for(sObject result: listSObjectResult){
                                if(customField.Custom_Chart_Related_Object__c != null){
                                    
                                    List<sObject> listSObjectRelated = new List<sObject>();
                                    try{
                                        listSObjectRelated = result.getSObjects(customField.Custom_Chart_Related_Object__r.Related_Object_API_Name__c);
                                    }catch(System.Exception e){
                                        ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The related list result of the query could not be recovered due to the following error: '+ e.getMessage()));
                                        System.debug('The related list result of the query could not be recovered due to the following error: '+ e.getMessage());
                                        return '';
                                    }
                                    if(listSObjectRelated != null && listSObjectRelated.size()>0){
                                        if(groupByBaseObject){
                                            String groupByValue = '';
                                            if(groupBy!=''){
	                                            try{
	                                                groupByValue = String.valueOf(result.get(groupByAPIName));
	                                            }catch(System.Exception e){
	                                                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The group by value could not be recovered due to the following error: '+ e.getMessage()));
	                                                System.debug('The group by value could not be recovered due to the following error: '+ e.getMessage());
	                                                return '';
	                                            }
                                            }
                                            if(groupByValue == groupBy){
                                                for(sObject related: listSObjectRelated){
                                                    String value = '';
                                                    String currencyIsoCode = 'USD';
                                                    try{
                                                        value = String.valueOf(related.get(customField.Field_API_Name__c));
                                                        currencyIsoCode = String.valueOf(related.get('CurrencyIsoCode'));
                                                    }catch(System.Exception e){
                                                        ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The field value could not be recovered due to the following error: '+ e.getMessage()));
                                                        System.debug('The field value could not be recovered due to the following error: '+ e.getMessage());
                                                        return '';
                                                    }
                                                    Decimal decimalValue = 0;
                                                    try{
                                                        decimalValue = Decimal.valueOf(value);
                                                    } catch(System.Exception e){
                                                        //NOTHING
                                                        decimalValue = 0;
                                                    }
                                                    decimalValue = decimalValue * mapRates.get(customChart.CurrencyIsoCode).get(currencyIsoCode);
                                                    if(customField.Type__c == 'Count' && value != ''){
                                                        countResult++;
                                                        summaryResult++;
                                                    }else if(customField.Type__c == 'Maximum'){
                                                        if(summaryResult < (decimalValue!=null?decimalValue:0)) summaryResult = (decimalValue!=null?decimalValue:0);
                                                    }else if(customField.Type__c == 'Minimum'){
                                                        if(summaryResult > (decimalValue!=null?decimalValue:0)) summaryResult = (decimalValue!=null?decimalValue:0); 
                                                    }else if(customField.Type__c == 'Average'){
                                                        countResult++;
                                                        summaryResult+=(decimalValue!=null?decimalValue:0);
                                                    }else if(customField.Type__c == 'Sum'){
                                                        summaryResult+=(decimalValue!=null?decimalValue:0);
                                                    }
                                                }
                                            }
                                        }else{
                                            for(sObject related: listSObjectRelated){
                                                String groupByValue = '';
                                                if(groupBy!=''){
	                                                try{
	                                                    groupByValue = String.valueOf(related.get(groupByAPIName)); 
	                                                }catch(System.Exception e){
	                                                    ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The group by value could not be recovered due to the following error: '+ e.getMessage()));
	                                                    System.debug('The field value could not be recovered due to the following error: '+ e.getMessage());
	                                                    return '';
	                                                }
                                                }
                                                if(groupByValue == groupBy){
                                                    String value = '';
                                                	String currencyIsoCode = 'USD';
                                                    try{
                                                        value = String.valueOf(related.get(customField.Field_API_Name__c));
                                                        currencyIsoCode = String.valueOf(related.get('CurrencyIsoCode'));
                                                    }catch(System.Exception e){
                                                        ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The group by value could not be recovered due to the following error: '+ e.getMessage()));
                                                        System.debug('The field value could not be recovered due to the following error: '+ e.getMessage());
                                                        return '';
                                                    }
                                                    Decimal decimalValue = 0;
                                                    try{
                                                        decimalValue = Decimal.valueOf(value);
                                                    } catch(System.Exception e){
                                                        //NOTHING
                                                        decimalValue = 0;
                                                    }
                                                    decimalValue = decimalValue * mapRates.get(customChart.CurrencyIsoCode).get(currencyIsoCode);
                                                    if(customField.Type__c == 'Count' && value != ''){
                                                        countResult++;
                                                        summaryResult++;
                                                    }else if(customField.Type__c == 'Maximum'){
                                                        if(summaryResult < (decimalValue!=null?decimalValue:0)) summaryResult = (decimalValue!=null?decimalValue:0);
                                                    }else if(customField.Type__c == 'Minimum'){
                                                        if(summaryResult > (decimalValue!=null?decimalValue:0)) summaryResult = (decimalValue!=null?decimalValue:0); 
                                                    }else if(customField.Type__c == 'Average'){
                                                        countResult++;
                                                        summaryResult+=(decimalValue!=null?decimalValue:0);
                                                    }else if(customField.Type__c == 'Sum'){
                                                        summaryResult+=(decimalValue!=null?decimalValue:0);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }else{
                                    String groupByValue = '';
                                    if(groupBy!=''){
	                                    try{
	                                        groupByValue = String.valueOf(result.get(groupByAPIName));
	                                    }catch(System.Exception e){
	                                        ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The group by value could not be recovered due to the following error: '+ e.getMessage()));
	                                        System.debug('The group by value could not be recovered due to the following error: '+ e.getMessage());
	                                        return '';
	                                    }
                                    }
                                    if(groupByValue == groupBy){
                                        String value = '';
                                        String currencyIsoCode = 'USD';
                                        try{
                                            value = String.valueOf(result.get(customField.Field_API_Name__c));
                                            currencyIsoCode = String.valueOf(result.get('CurrencyIsoCode'));
                                        }catch(System.Exception e){
                                            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'The field value could not be recovered due to the following error: '+ e.getMessage()));
                                            System.debug('The field value could not be recovered due to the following error: '+ e.getMessage());
                                            return '';
                                        }
                                        Decimal decimalValue = 0;
                                        try{
                                            decimalValue = Decimal.valueOf(value);
                                        } catch(System.Exception e){
                                            //NOTHING
                                            decimalValue = 0;
                                        }
										decimalValue = decimalValue * mapRates.get(customChart.CurrencyIsoCode).get(currencyIsoCode);
                                        if(customField.Type__c == 'Count' && value != ''){
                                            countResult++;
                                        }else if(customField.Type__c == 'Maximum'){
                                            if(summaryResult < (decimalValue!=null?decimalValue:0)) summaryResult = (decimalValue!=null?decimalValue:0);
                                        }else if(customField.Type__c == 'Minimum'){
                                            if(summaryResult > (decimalValue!=null?decimalValue:0)) summaryResult = (decimalValue!=null?decimalValue:0); 
                                        }else if(customField.Type__c == 'Average'){
                                            countResult++;
                                            summaryResult+=(decimalValue!=null?decimalValue:0);
                                        }else if(customField.Type__c == 'Sum'){
                                            summaryResult+=(decimalValue!=null?decimalValue:0);
                                        }
                                    }
                                }
                            }
                            
                            Decimal finalResult = 0;
                            if(customField.Type__c == 'Average'){
                                finalResult = (summaryResult/countResult).setScale(2, System.Roundingmode.HALF_EVEN);
                            }else{
                                finalResult = summaryResult;
                            }
                            
                            if(customField.Display_On_Chart__c){
                                if(finalResult < minimum) minimum = finalResult;
                                if(finalResult > maximum) maximum = finalResult;
                            }
                            
                            Map<String, String> mapResult = new Map<String, String>();
                            Map<String, Boolean> mapResultDisplay = new Map<String, Boolean>();
                            if(mapParameters.containsKey(groupBy)){
                                mapResult = mapParameters.get(groupBy);
                            }
                            if(mapParametersOnChart.containsKey(groupBy)){
                                mapResultDisplay = mapParametersOnChart.get(groupBy);
                            }
                            
                            mapResult.put(customField.Chart_Field_Number__c, String.valueOf(finalResult));
                            mapResultDisplay.put(customField.Chart_Field_Number__c, customField.Display_On_Chart__c);
                            System.debug('Mostrar campo #'+customField.Chart_Field_Number__c+': '+customField.Display_On_Chart__c);
                            
                            mapParameters.put(groupBy, mapResult);
                            mapParametersOnChart.put(groupBy, mapResultDisplay);
                        }
                    }
                }
                
                for(String groupBy: mapGroupBy.keySet()){
                	for(Custom_Chart_Field__c customField: (List<Custom_Chart_Field__c>) customChart.Custom_Chart_Fields__r){
                        if(customField.Field_Use__c == 'Formula'){
                            mapColors.put(customField.Chart_Field_Number__c, customField.Display_Color_Hex_Code__c);
                            if(mapChartField.containsKey(customField.Custom_Chart_Field_Number_A__c) 
                                    && mapChartField.containsKey(customField.Custom_Chart_Field_Number_B__c)){
                                for(String groupByParam :mapParameters.keySet()){
                                    Map<String, String> mapResult = mapParameters.get(groupByParam);
                                    Map<String, Boolean> mapResultDisplay = mapParametersOnChart.get(groupByParam);
                                    
                                    Decimal value1 = 0;
                                    Decimal value2 = 0;
                                    
                                    try{
                                        value1 = Decimal.valueOf(mapResult.get(customField.Custom_Chart_Field_Number_A__c));
                                    }catch(System.Exception e){
                                        
                                    }
                                    try{
                                        value2 = Decimal.valueOf(mapResult.get(customField.Custom_Chart_Field_Number_B__c));
                                    }catch(System.Exception e){
                                        
                                    }
                                    
                                    Decimal formulaResult = 0;
                                    if(customField.Operator__c == 'Add')
                                        formulaResult = value1 + value2;
                                    if(customField.Operator__c == 'Subtract')
                                        formulaResult = value1 - value2;
                                    if(customField.Operator__c == 'Multiply')
                                        formulaResult = value1 * value2;
                                    if(customField.Operator__c == 'Divide')
                                        formulaResult = (value2!=0?value1 / value2:0);
                                    
                                    if(customField.Display_On_Chart__c){   
                                        if(formulaResult < minimum) minimum = formulaResult;
                                        if(formulaResult > maximum) maximum = formulaResult;
                                    }
                                    
                                    mapResult.put(customField.Chart_Field_Number__c, String.valueOf(formulaResult));
                                    mapParameters.put(groupByParam, mapResult);
                                    
                                    System.debug('Mostrar campo #'+customField.Chart_Field_Number__c+': '+customField.Display_On_Chart__c);
                                    mapResultDisplay.put(customField.Chart_Field_Number__c, customField.Display_On_Chart__c);
                                    mapParametersOnChart.put(groupByParam, mapResultDisplay);
                                }
                            }
                        }
                    }
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'At least one group by field must exist.'));
                System.debug('At least one group by field must exist.');
                return '';
            }
            
            
            
            if(mapParameters.size()>0){
                chartURL = 'https://chart.googleapis.com/chart?chs='+Integer.valueOf(customChart.Width__c)+'x'+Integer.valueOf(customChart.Height__c)
                        +(customChart.Type__c=='Bar Chart'?'&chbh=a':'')
                        +(customChart.Type__c=='Column Chart'?'&chbh=a':'')
                        +'&cht='+chartType.get(customChart.Type__c)
                        +'&chtt='+(customChart.Name).replace(' ','+')
                        +'&chxr=1,'+(customChart.Type__c != 'Pie Chart'?String.valueOf(minimum)+','+String.valueOf(maximum):'');
                chartURL += '&chdlp=b&chxt=x,y';
                String mappedValue = '';
                String mappedLegend = '';
                String mappedLabel = '';
                String mappedAxis = '';
                String mappedColors = '';
                String mappedDataSetStyle = '';
                Decimal totalResultValue = 0;
                
                Integer amountDataSets = 0;
                
                Map<String, Integer> mapDataSet = new Map<String, Integer>();
                
                for(String groupBy: mapParameters.keySet()){
                	String groupBy_T = groupBy.replace(' ','+');
                	groupBy_T = groupBy.replace('&','%26');
                    mappedAxis += (mappedAxis.length()>0?'|':'&chxl=0:|')+groupBy_T; 
                    if(mapParameters.get(groupBy).keySet().size()>amountDataSets){ 
                        amountDataSets=0;
                        for(Integer i=0; i<=mapParameters.get(groupBy).size(); i++){
                        	if(mapIndexCustomField.containsKey(i)){
                        		String summary=mapIndexCustomField.get(i);
	                            mapDataSet.put(summary, amountDataSets);
	                            amountDataSets++;
                        	}
                        }
                    }
                    if(customChart.Type__c == 'Pie Chart'){
                        for(String result: mapParameters.get(groupBy).values()){
                            try{
                                totalResultValue += Decimal.valueOf(result);
                            }catch(System.Exception e){
                                totalResultValue += 0;
                            }
                        }
                    }
                }
                String[] listDataSets = new String[amountDataSets];
                for(Integer i=0; i<amountDataSets;i++){
                    listDataSets[i] = '';
                }
                for(String groupBy: mapParameters.keySet()){
                    if(customChart.Type__c == 'Pie Chart'){
                        Map<String, String> mapResultValue = mapParameters.get(groupBy);
                        Map<String, Boolean> mapResultDisplay = mapParametersOnChart.get(groupBy);
                        Decimal decimalResult = 0;
                        String color = '';
                        for(Integer i=0; i<=mapResultValue.size(); i++){
                        	if(mapIndexCustomField.containsKey(i)){
	                        	String summary = mapIndexCustomField.get(i);
	                        	System.debug('Obtener resumen de campo: '+summary);
	                            if(mapResultDisplay.containsKey(summary) && mapResultDisplay.get(summary)){
	                                String result = mapResultValue.get(summary);
	                                color=(color.length()>0?',':'&chco=') + groupByBaseColor;
	                                try{
	                                    decimalResult += Decimal.valueOf(result);
	                                }catch(System.Exception e){
	                                    decimalResult += 0;
	                                }
	                            }
                        	}
                        }
                        String groupBy_T =  groupBy.replace(' ','+');
                        groupBy_T =  groupBy_T.replace('&','%26');
                        mappedValue+=(mappedValue.length()>0?',':'&chd=t:') + String.valueOf(((decimalResult/totalResultValue)*100).setScale(4, System.Roundingmode.HALF_EVEN));
                        mappedLegend+=(mappedLegend.length()>0?'|':'&chdl=') + groupBy_T;
                        mappedColors = color;
                        mappedLabel+=(mappedLabel.length()>0?'|':'&chl=') + String.valueOf(((decimalResult/totalResultValue) * 100).setScale(2, System.Roundingmode.HALF_EVEN)) + '%';
                        
                    }else{
                        
                        Map<String, String> mapResultValue = mapParameters.get(groupBy);
                        Map<String, Boolean> mapResultDisplay = mapParametersOnChart.get(groupBy);
                        
                        String legend = '';
                        String colors = '';
                        String dataSetStyle  = '';
                        for(Integer i=0; i<=mapResultValue.size(); i++){
                        	if(mapIndexCustomField.containsKey(i)){
	                        	String summary = mapIndexCustomField.get(i);
	                        	System.debug('Obtener resumen de campo: '+summary);
	                        	System.debug('Debe mostrar campo resumen #'+summary+': '+mapResultDisplay.get(summary));
	                            if(mapResultDisplay.containsKey(summary) && mapResultDisplay.get(summary)){
	                            	String summary_T = mapChartField.get(summary);
	                            	summary_T = summary_T.replace('&','%26'); 
	                            	summary_T = summary_T.replace(' ','+');
	                            	System.debug('Nombre de resumen de campo: '+summary_T);
	                                legend+=(legend.length()>0?'|':'&chdl=') + summary_T + ' (' + customChart.CurrencyIsoCode + ' ' + Decimal.valueOf(mapResultValue.get(summary)).setScale(2, System.Roundingmode.HALF_EVEN).format() + ')';
	                                dataSetStyle += (dataSetStyle.length()>0?',':'&chds=') + minimum+','+maximum;
	                                colors+=(colors.length()>0?',':'&chco=') + mapColors.get(summary);
	                                Integer dataSetIndex = mapDataSet.get(summary);
	                                listDataSets[dataSetIndex] += ((listDataSets[dataSetIndex]).length()>0?',':'') + mapResultValue.get(summary);
	                            }
                        	}
                        }
                        
                        if(mappedDataSetStyle != dataSetStyle && dataSetStyle.length()>0) mappedDataSetStyle = dataSetStyle;
                        if(mappedLegend != legend && legend.length()>0) mappedLegend = legend;
                        if(mappedColors != colors && colors.length()>0) mappedColors = colors;
                    }
                }
                for(String dataSet: listDataSets){
                    if(dataSet.length()>0) mappedValue+=(mappedValue.length()>0?'|':'&chd=t:') + dataSet;
                }
                chartURL +=mappedValue+mappedLegend+mappedLabel+mappedAxis+mappedColors+mappedDataSetStyle;
                System.debug('Chart URL is: '+ chartURL);
            }
        }
        
        return chartURL;
    }
    
    public static map<String, map<String, decimal>> getConversionRate(){
        List<DatedConversionRate> listaMonedas = new List<DatedConversionRate>();
        listaMonedas = [SELECT Id, ConversionRate, IsoCode FROM DatedConversionRate Order By CreatedDate ASC];
        map<String, map<String, decimal>> mapaRetorno = new map<String, map<String, decimal>>();
        for(DatedConversionRate item :listaMonedas){
            map<String, Decimal> mapa = new map<String, decimal>(); 
            for(DatedConversionRate convert :listaMonedas){
                mapa.put(convert.IsoCode, (item.ConversionRate/convert.ConversionRate));
            }
            mapaRetorno.put(item.IsoCode, mapa);
        }
        return mapaRetorno;
    }
    
    public static Id getRecordTypeId_MarketAccount(){
    	RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' 
    					AND DeveloperName = 'Market_Accounts_for_Backlog_Targets'
    					AND IsActive = true];
    	return rt.Id;
    }
}