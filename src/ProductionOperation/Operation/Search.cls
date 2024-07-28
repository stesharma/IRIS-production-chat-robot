Class ProductionOperation.Operation.Search Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// Description
Method Search(pRequest As ProductionOperation.Message.Request, Output pResponse As Ens.StringResponse) As %Status
{
    Set sc = $$$OK
    Set arr =[]
    Set response =##class(ProductionOperation.Util.Response).%New()
    Set pResponse = ##class(Ens.StringResponse).%New()
    // do something
    Try {
	    Set request =pRequest.parameter.GetAt(1)
        Set json  =##class(%DynamicObject).%FromJSON(pRequest.parameter.GetAt(1))
    	Set user=json.user	
        Set statement = ##class(%SQL.Statement).%New(1)
        Set sql = " SELECT ID, Chat,  Name FROM ProductionOperation_DB.Chat where  Name like '%"_user_"' order by id "
        Set qStatus = statement.%Prepare(sql)
        set tResult = statement.%Execute()
        while tResult.%Next(){
	       Set chat={}
		   Set chat.ID =tResult.%Get("ID")
		   Set chat.message =tResult.%Get("Chat")
		   Set chat.Name =tResult.%Get("Name")
		   d arr.%Push(chat)
		}
		
		Set str = response.Success(arr,"SUCCESS")
 
    }
    Catch ex {
        Set sc=ex.AsStatus()
         Set ^Log($ZDT($NOW(),3,,6))="Erropr sc: "_sc
        Set str=response.Error(sc)
    }
	Set pResponse.StringValue = $REPLACE(str.%ToJSON(),"\u0000","")
    Return sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="ProductionOperation.Message.Request"> 
		<Method>Search</Method>
	</MapItem>
</MapItems>
}

}

