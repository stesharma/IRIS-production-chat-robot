Class ProductionOperation.Operation.CreateService Extends %RegisteredObject
{

/// Description
ClassMethod Create(json, Output msg) As %Status
{
    Set sc = $$$OK
    Set tSC = ##class(Ens.Director).GetProductionStatus(.productionName,.tState,,1)
        Set ^Log($ZDT($NOW(),3,,6))= productionName
		// Is there a service with the same name
		&sql(select count(1) into :num FROM Ens_Config.Item where Name=:json.Name and Production = :productionName)
        Set ^Log($ZDT($NOW(),3,,6))= "num "_num
		if num >0 {
			Set msg="A service with the same name already exists, please check the service name"
			Quit $$$NO
		}
       // create service
       Set production = ##class(Ens.Config.Production).%OpenId(productionName)
       Set item= ##class(Ens.Config.Item).%New()
       // Name
       Set item.Name=json.Name
       // ClassName
       Set item.ClassName=json.ClassName
       // Comment
       Set item.Comment=json.Comment
       // Enabled
       if json.Enabled =1 {Set item.Enabled =1}else{Set item.Enabled =0}
       // PoolSize
       Set item.PoolSize=json.PoolSize 	
       // Category
       Set item.Category = json.Category

       Set settingArr=json.Settings
       Set iter= settingArr.%GetIterator()	
       while iter.%GetNext(.key , .value )	
       {
           Set setting=##class(Ens.Config.Setting).%New()
           Set setting.Target=value.Target
           Set setting.Name=value.Name
           Set setting.Value=value.Value
           D item.Settings.Insert(setting)		
       }
       Do ##class(Ens.Util.Auditing).AuditModifyProductionConfig(production.Name,item.Name,"Item added to production using generator in " _ $classname())
       Do ##class(EnsPortal.Template.prodConfigSCPage).CallProductionUpdateAndSaveToClass(production,item,"InsertItem") 
       Do ##class(Ens.Director).UpdateProduction() 
    Return sc
}

}

