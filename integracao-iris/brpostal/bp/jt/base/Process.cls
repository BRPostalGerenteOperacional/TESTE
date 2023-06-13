Class brpostal.bp.jt.base.Process Extends Ens.BusinessProcess
{

Property Server As %String(MAXLEN = 100);

Property Port As %Integer;

Property Url As %String(MAXLEN = 100);

Property SSLCheckServerIdentity As %Boolean;

Property SSLConfig As %String;

Property TypeRest As %String;

Property ContentType As %String(MAXLEN = 50) [ InitialExpression = "application/x-www-form-urlencoded" ];

Parameter SETTINGS = "Server:Rest Config,Port:Rest Config,Url:Rest Config,SSLCheckServerIdentity:Rest Config,SSLConfig:Rest Config:sslConfigSelector,TypeRest:Rest Config,ContentType:Rest Config";

Method OnRequest(pRequest As %Persistent, Output pResponse As %Persistent) As %Status
{
    Quit $$$OK
}

Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
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
<Value name="7">
<Value>CustomerCode</Value>
</Value>
<Value name="8">
<Value>Pwd</Value>
</Value>
<Value name="9">
<Value>PrivateKey</Value>
</Value>
<Value name="10">
<Value>apiAccount</Value>
</Value>
<Value name="11">
<Value>ContentType</Value>
</Value>
</Data>
<DefaultData>ProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
