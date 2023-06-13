Class brpostal.bo.jet.generateDigest.msg.Request Extends Ens.Request
{

Property CustomerCode As %String(MAXLEN = 40);

Property Pwd As %String(MAXLEN = 40);

Property PrivateKey As %String(MAXLEN = 40);

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>CustomerCode</Value>
</Value>
<Value name="2">
<Value>Pwd</Value>
</Value>
<Value name="3">
<Value>PrivateKey</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
