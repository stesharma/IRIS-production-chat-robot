Class ProductionOperation.Message.Request Extends Ens.Request
{

/// method
Property method As %String(XMLNAME = "METHOD");

/// paparameterrm
Property parameter As list Of %String(MAXLEN = "", XMLNAME = "parameter", XMLPROJECTION = "element");

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>method</Value>
</Value>
<Value name="2">
<Value>parameter</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

