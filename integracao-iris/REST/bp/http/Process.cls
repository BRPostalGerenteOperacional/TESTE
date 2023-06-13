Class REST.bp.http.Process Extends Ens.BusinessProcess
{

Property Server As %String(MAXLEN = 100);

Property Port As %Integer;

Property Url As %String(MAXLEN = 100);

Property SSLCheckServerIdentity As %Boolean;

Property SSLConfig As %String;

Property TypeRest As %String;

Parameter SETTINGS = "Server:Rest Config,Port:Rest Config,Url:Rest Config,SSLCheckServerIdentity:Rest Config,SSLConfig:Rest Config:sslConfigSelector,TypeRest:Rest Config";

Method OnRequest(pRequest As REST.bp.http.msg.Request, Output pResponse As REST.bp.http.msg.Response) As %Status
{
    Set tSC = $$$OK

    Quit tSC
}

/// Handle a 'Response'
Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	// Subclass responsibility
	Quit $$$OK
}

Storage Default
{
<Data name="ProcessDefaultData">
<Subscript>"Process"</Subscript>
<Value name="1">
<Value>Server</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>Url</Value>
</Value>
<Value name="4">
<Value>SSLCheckServerIdentity</Value>
</Value>
<Value name="5">
<Value>SSLConfig</Value>
</Value>
<Value name="6">
<Value>TypeRest</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
