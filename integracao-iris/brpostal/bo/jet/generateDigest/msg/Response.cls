Class brpostal.bo.jet.generateDigest.msg.Response Extends Ens.Response
{

Property digest As %String(MAXLEN = "");

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>digest</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
