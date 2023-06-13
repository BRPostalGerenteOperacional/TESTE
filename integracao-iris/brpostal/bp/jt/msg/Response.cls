Class brpostal.bp.jt.msg.Response Extends REST.bo.http.msg.Response
{

Property transformedJson As %String(MAXLEN = "");

Storage Default
{
<Data name="ResponseDefaultData1">
<Subscript>"Response1"</Subscript>
<Value name="1">
<Value>transformedJson</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
