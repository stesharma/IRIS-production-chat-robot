/// 
Class ProductionOperation.BP.Chat Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='600' >
<switch name='chat' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.method="add"' >
<call name='message' target='ProductionOperation.Operation.Chat' async='0' xpos='335' ypos='400' >
<request type='ProductionOperation.Message.Request' >
<assign property="callrequest" value="request" action="set" languageOverride="" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" languageOverride="" />
</response>
</call>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

