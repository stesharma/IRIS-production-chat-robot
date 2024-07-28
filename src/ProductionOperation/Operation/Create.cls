Class ProductionOperation.Operation.Create Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// Description
Method AddService(pRequest As ProductionOperation.Message.Request, Output pResponse As Ens.StringResponse) As %Status
{
    Set sc = $$$OK
    Set ^Log($ZDT($NOW(),3,,6))=" start BO"_pRequest
    Set response =##class(ProductionOperation.Util.Response).%New()
    Set pResponse = ##class(Ens.StringResponse).%New()
    // do something
    Try {
	    Set request =pRequest.parameter.GetAt(1)
        Set json  =##class(%DynamicObject).%FromJSON(pRequest.parameter.GetAt(1))
        Set Production =##Class(ProductionOperation.Operation.CreateService).%New()
        Set tsc =Production.Create(json,.out)
        if tsc{
            Set str = response.Success("","SUCCESS")
            Do ##class(Ens.Director).UpdateProduction() 
        }else{
            Set str = response.Error(out)
        }
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
		<Method>AddService</Method>
	</MapItem>
</MapItems>
}

}

