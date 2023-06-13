Class REST.vo.http.SendData Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property Server As %String(MAXLEN = 500);

Property Port As %Integer;

Property UrlBase As %String;

Property ContentType As %String;

Property Url As %String(MAXLEN = 500);

Property ComplementUrl As %String(MAXLEN = "");

Property Contents As %Stream.GlobalCharacter;

Property Headers As list Of %String(MAXLEN = "");

// Property FormEncoded As %ArrayOfDataTypes;

Property FormEncoded As list Of %String(MAXLEN = "");

Property Params As list Of %String(MAXLEN = "");

Property Type As %String;

Property SSLCheckServerIdentity As %Boolean [ InitialExpression = 0 ];

Property SSL As %String;

Storage Default
{
<Data name="SendDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Server</Value>
</Value>
<Value name="3">
<Value>Port</Value>
</Value>
<Value name="4">
<Value>UrlBase</Value>
</Value>
<Value name="5">
<Value>ContentType</Value>
</Value>
<Value name="6">
<Value>Url</Value>
</Value>
<Value name="7">
<Value>ComplementUrl</Value>
</Value>
<Value name="8">
<Value>Contents</Value>
</Value>
<Value name="9">
<Value>Headers</Value>
</Value>
<Value name="10">
<Value>FormEncoded</Value>
</Value>
<Value name="11">
<Value>Params</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
<Value name="13">
<Value>SSLCheckServerIdentity</Value>
</Value>
<Value name="14">
<Value>SSL</Value>
</Value>
</Data>
<DataLocation>^REST.vo.http.SendDataD</DataLocation>
<DefaultData>SendDataDefaultData</DefaultData>
<IdLocation>^REST.vo.http.SendDataD</IdLocation>
<IndexLocation>^REST.vo.http.SendDataI</IndexLocation>
<StreamLocation>^REST.vo.http.SendDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
