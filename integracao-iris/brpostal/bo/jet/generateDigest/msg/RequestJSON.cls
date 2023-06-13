Class brpostal.bo.jet.generateDigest.msg.RequestJSON Extends Ens.Request
{

Property json As %String(MAXLEN = "");

Property PrivateKey As %String(MAXLEN = 40);

Storage Default
{
<Data name="RequestJSONDefaultData">
<Subscript>"RequestJSON"</Subscript>
<Value name="1">
<Value>json</Value>
</Value>
<Value name="2">
<Value>PrivateKey</Value>
</Value>
</Data>
<DefaultData>RequestJSONDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
