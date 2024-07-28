Class Production.ChatVectorSearch Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Production.ChatVectorSearch" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>20</ActorPoolSize>
  <Item Name="ProductionOperation.Vector.Service" Category="" ClassName="ProductionOperation.Vector.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="ProductionOperation.Operation.Create" Category="" ClassName="ProductionOperation.Operation.Create" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="ProductionOperation.BP.Vector" Category="" ClassName="ProductionOperation.BP.Vector" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="ProductionOperation.Operation.Chat" Category="" ClassName="ProductionOperation.Operation.Chat" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="apiKey"></Setting>
  </Item>
  <Item Name="ProductionOperation.BP.Chat" Category="" ClassName="ProductionOperation.BP.Chat" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="ProductionOperation.Operation.Search" Category="" ClassName="ProductionOperation.Operation.Search" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}

