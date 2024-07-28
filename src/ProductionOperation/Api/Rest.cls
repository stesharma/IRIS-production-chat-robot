Class ProductionOperation.Api.Rest Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

Parameter CHARSET = "UTF-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.native.rest.com/urlmap" ]
{
<Routes>
  <Route Url="/*" Method="OPTIONS" Call="GetStatus"/>
  <Route Url="/Vector/:Method" Method="POST" Call="Vector"/>
  <Route Url="/Chat/:Method" Method="POST" Call="Chat"/>
</Routes>
}

ClassMethod GetStatus(ser As %String) As %Status
{
     Quit $$$OK
}

ClassMethod Vector(Method As %String) As %Status
{
    Set Util = ##Class(ProductionOperation.Util.Response).%New()
    Set msg=##class(ProductionOperation.Message.Request).%New()
    kill ^Log
	Try{
		Set content=""
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
		Set msg.method=Method
		d msg.parameter.Insert(content)
		Set tSC=##class(Ens.Director).CreateBusinessService("ProductionOperation.Vector.Service",.Service)
		Set tsc = Service.Send("ProductionOperation.BP.Vector",msg,.out)
		Set ^Log($ZDT($NOW(),3,,6))="tsc : "_tsc
	   	set message=out.StringValue
	}Catch(e){
		Set ^Log($ZDT($NOW(),3,,6))="ERROR :"_e.DisplayString()
		Set message =Util.Error(e.DisplayString()).%ToJSON()
	}
    w message
    Quit $$$OK
}

ClassMethod Chat(Method As %String) As %Status
{
    Set Util = ##Class(ProductionOperation.Util.Response).%New()
    Set msg=##class(ProductionOperation.Message.Request).%New()
    kill ^Log
	Try{
		Set content=""
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
		Set msg.method=Method
		d msg.parameter.Insert(content)
		Set tSC=##class(Ens.Director).CreateBusinessService("ProductionOperation.Vector.Service",.Service)
		Set tsc = Service.Send("ProductionOperation.BP.Chat",msg,.out)
		Set ^Log($ZDT($NOW(),3,,6))="tsc : "_tsc
	   	set message=out.StringValue
	}Catch(e){
		Set ^Log($ZDT($NOW(),3,,6))="ERROR :"_e.DisplayString()
		Set message =Util.Error(e.DisplayString()).%ToJSON()
	}
    w message
    Quit $$$OK
}

}

