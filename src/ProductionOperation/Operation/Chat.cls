Class ProductionOperation.Operation.Chat Extends Ens.BusinessOperation
{

Parameter SETTINGS = "apiKey:Basic";

Property apiKey As %String(MAXLEN = 200);

Method ChatServer(pRequest As ProductionOperation.Message.Request, Output pResponse As Ens.StringResponse) As %Status
{
    Set sc = $$$OK
    Set ^Log($ZDT($NOW(),3,,6))=" start BO"_pRequest
    Set response =##class(ProductionOperation.Util.Response).%New()
    Set pResponse = ##class(Ens.StringResponse).%New()
    // do something
    Try {
	    Set request =pRequest.parameter.GetAt(1)
	    Set ^Log($ZDT($NOW(),3,,6))=" request: "_request
        Set json  =##class(%DynamicObject).%FromJSON(pRequest.parameter.GetAt(1))
        // 
        Set user = json.user
        Set message = json.message
        &SQL(insert into ProductionOperation_DB.Chat (Name,Chat) values (:user,:message) )
        // %ROWID
         Set ^Log($ZDT($NOW(),3,,6))=" %ROWID: "_%ROWID
        job ##class(ProductionOperation.Operation.Vector).ChatUpdate(%ROWID,message)
        // 
         $$$LOGINFO(" messgae "_message)
        if ..check(message,9){
            //production operation
            $$$LOGINFO(" operation")
            Set msg ="operation"
            if "delte" =..checkOperation(message){
                Set msg ="delte opoperatione"

            }elseif "update" =..checkOperation(message)
            {
                Set msg ="update operation"

            }elseif "create" =..checkOperation(message)
            {
                 $$$LOGINFO(" create")
                Set msg ="create operation"
                if 1 =..check(message,2)
                {
                    Set msg ="create Service"
                    // create service
                    Set obj ={
                                "Name": "",
                                "Comment": "",
                                "Enabled": "1",
                                "PoolSize": "0",
                                "ClassName": "EnsLib.SOAP.GenericService",
                                "Settings": [
                                    {
                                        "Target": "Host",
                                        "Name": "AlertOnError",
                                        "Value": "0"
                                    }
                                ]
                            }
                    Set Name1 ="EnsLib.SOAP.GenericService",Name =Name1
                    Set tSC = ##class(Ens.Director).GetProductionStatus(.productionName,.tState,,1)
                    Set i=0
                    while 1{
                        Set i= i+1
                        &sql(select count(1) into :num FROM Ens_Config.Item where Name=:Name and Production = :productionName)
                        if num >0{
                            Set Name =  Name1_i  
                        }else{
                            Quit
                        }
                        
                    }
                    Set ^Log($ZDT($NOW(),3,,6))=" Name: "_Name

                    S obj.Name =Name 
                    S obj.Comment =msg 
                    // call http 
                    Set http =##class(ProductionOperation.Operation.HttpCall).%New()
                    Set tsc =http.POST("127.0.0.1","52773","/api/Vector/AddService",obj.%ToJSON(),.Output)
                    Set result  =##class(%DynamicObject).%FromJSON(Output)
                    if result.code=200{
                           Set msg =  Name_" created successfully"  
                           
                    }else{
                       Set msg =   result.message 
                    }


                }elseif 1 =..check(message,1)
                {
                    Set msg ="create Operation"
                    // create operation
                }else{
                    Set msg = "Sorry, this feature is currently not supported "
                }
            }elseif "search" =..checkOperation(message){
                &SQL(select id into :id from ProductionOperation_DB.Chat where id !=:%ROWID order by id  desc )
                Set sql="select top 5 count(1) as total , id as vid,Chat,VECTOR_COSINE(TO_VECTOR(ChatVector,double),"
                    _"(select TO_VECTOR(ChatVector,double) from ProductionOperation_DB.Chat where id= "_id_")) Similarity "
                    _"from ProductionOperation_DB.Chat where ChatVector is not null order by Similarity desc"
                Set statement = ##class(%SQL.Statement).%New(1)
                Set qStatus = statement.%Prepare(sql)
                set tResult = statement.%Execute()
                Set j =1,msg="The current similarity of the problem is as follows:"_$C(10)
                while tResult.%Next(){
                    Set msg =msg_j_"."_tResult.%Get("Chat")_"   "_tResult.%Get("Similarity")_$C(10)
                    S j=j+1
                }

            }



        }else{
            $$$LOGINFO(" chatgpt ")
            //chatgpt 
            
            Set msg =##class(ProductionOperation.OpenAi.Message).MethodName(..apiKey,message)

        }

        Set ^Log($ZDT($NOW(),3,,6)) ="msgmsg:"_msg
        Set ^Log($ZDT($NOW(),3,,6)) ="msgmsg:"_user
        Set robotUser="robot:"_user
        &SQL(insert into ProductionOperation_DB.Chat (Name,Chat) values (:robotUser,:msg) )
        
        Set str = response.Success(msg,"SUCCESS")
    }
    Catch ex {
        Set sc=ex.AsStatus()
         Set ^Log($ZDT($NOW(),3,,6))="Erropr sc: "_sc
        Set str=response.Error(sc)
    }
	Set pResponse.StringValue = $REPLACE(str.%ToJSON(),"\u0000","")
    Return sc
}

Method check(phrase, flag) [ Language = python ]
{
    
    if flag ==1:
        substrings = ["Operation", "BO"]
    elif flag ==2:
        substrings = ["Service", "BS"]
    else:
        substrings = ["create","delte","update","Service", "BS", "Operation", "BO","search"]
    phrase_lower = phrase.lower()
    for substring in substrings:
        if substring.lower() in phrase_lower:
            return True
    return False
}

Method checkOperation(phrase) [ Language = python ]
{
 
    substrings = ["create", "delete", "update","search"]
    phrase_lower = phrase.lower()
    
    for substring in substrings:
        if substring in phrase_lower:
            return substring
    
    return False
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="ProductionOperation.Message.Request"> 
		<Method>ChatServer</Method>
	</MapItem>
</MapItems>
}

}

