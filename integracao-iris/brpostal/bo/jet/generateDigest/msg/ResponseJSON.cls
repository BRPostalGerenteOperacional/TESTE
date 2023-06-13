Class brpostal.bo.jet.generateDigest.msg.ResponseJSON Extends Ens.Response
{

Property digest As %String(MAXLEN = "");

Storage Default
{
<Data name="ResponseJSONDefaultData">
<Subscript>"ResponseJSON"</Subscript>
<Value name="1">
<Value>digest</Value>
</Value>
</Data>
<DefaultData>ResponseJSONDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
