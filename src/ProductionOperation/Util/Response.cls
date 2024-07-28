Class ProductionOperation.Util.Response Extends %RegisteredObject
{

/// Return a successful response
Method Success(data As %String = "", message As %String = "") As %Status
{
    Set object ={"code":"200","data":"","message":""}
    if $l(data)'=0 Set object.data =data
    if $l(message)'=0 Set object.message =message
    Return object
}

/// Return a error response
Method Error(message As %String = "") As %Status
{
    Set object ={"code":"500","message":""}
    if $l(message)'=0 Set object.message =message
    Return object
}

}

