Class ProductionOperation.DB.Chat Extends %Persistent
{

Property Name As %String(MAXLEN = 200);

Property Chat As %String;

Property ChatVector As %Library.Vector(DATATYPE = "double", LEN = 384);

Storage Default
{
<Data name="ChatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Chat</Value>
</Value>
<Value name="4">
<Value>ChatVector</Value>
</Value>
</Data>
<DataLocation>^ProductionOperation.DB.ChatD</DataLocation>
<DefaultData>ChatDefaultData</DefaultData>
<ExtentSize>5</ExtentSize>
<IdLocation>^ProductionOperation.DB.ChatD</IdLocation>
<IndexLocation>^ProductionOperation.DB.ChatI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Chat">
<AverageFieldSize>10.2</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ChatVector">
<AverageFieldSize>1704.8</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>8.4</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-12</BlockCount>
</SQLMap>
<StreamLocation>^ProductionOperation.DB.ChatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

