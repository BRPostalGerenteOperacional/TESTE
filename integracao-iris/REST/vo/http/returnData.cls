Class REST.vo.http.returnData Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property StatusCode As %String;

Property StatusLine As %String(MAXLEN = "");

Property StatusMessage As %String(MAXLEN = "");

Property Contents As %Stream.GlobalCharacter;

Property Status As %Status;

Property SessionId As %String(MAXLEN = 100);

Storage Default
{
<Data name="returnDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
<Value name="3">
<Value>StatusLine</Value>
</Value>
<Value name="4">
<Value>StatusMessage</Value>
</Value>
<Value name="5">
<Value>Contents</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>SessionId</Value>
</Value>
</Data>
<DataLocation>^REST.vo.http.returnDataD</DataLocation>
<DefaultData>returnDataDefaultData</DefaultData>
<IdLocation>^REST.vo.http.returnDataD</IdLocation>
<IndexLocation>^REST.vo.http.returnDataI</IndexLocation>
<StreamLocation>^REST.vo.http.returnDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
