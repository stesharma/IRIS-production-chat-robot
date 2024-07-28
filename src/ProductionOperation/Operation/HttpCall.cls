Class ProductionOperation.Operation.HttpCall Extends %RegisteredObject
{

/// Call post request
ClassMethod POST(ip As %String, port As %String, path As %String, body As %String, Output HttpResponse As %String(MAXLEN=256000)) As %Status
{
	
	Set httpRequest=##class(%Net.HttpRequest).%New()
	Do httpRequest.SetHeader("Content-Type","application/json+fhir")
	Do httpRequest.SetHeader("Accept","*/*")
    Set httpRequest.Port=port
    Set httpRequest.Server=ip
    Set httpRequest.Https=0
    Set httpRequest.Timeout=600
    Set httpRequest.ContentCharset="UTF-8"
    Set httpRequest.ContentEncoding="UTF-8"
    d httpRequest.EntityBody.Write(body)
    Set status=httpRequest.Post(path)
    IF 'status {
	    Set HttpResponse = "Connection failed, call exception"
	    return "Connection failed, call exception："_$SYSTEM.Status.GetErrorText(status)
	}
    Set response = httpRequest.HttpResponse
    Set ResponseData = response.Data
    Set HttpResponse=""
    while 'ResponseData.AtEnd{
	    Set HttpResponse=HttpResponse_ResponseData.Read()
    }

    return $$$OK
}

}

