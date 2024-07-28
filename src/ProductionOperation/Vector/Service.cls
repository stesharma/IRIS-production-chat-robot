Class ProductionOperation.Vector.Service Extends Ens.BusinessService
{

Method Send(TargetConfigName As %String, pInput As %RegisteredObject, Output pOutput As Ens.StringResponse) As %Status
{
  	try{
		Set tSC=..SendRequestSync(TargetConfigName,pInput,.Output)
		Set pOutput=##class(Ens.StringResponse).%New()
		Set pOutput=Output
	}catch ex{
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

}

