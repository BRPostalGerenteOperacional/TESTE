Class brpostal.bp.jt.msg.Request Extends REST.bo.http.msg.Request
{

Property CustomerCode As %String(MAXLEN = 40);

Property Pwd As %String(MAXLEN = 40);

Property PrivateKey As %String(MAXLEN = 40);

Property apiAccount As %String(MAXLEN = 60);

Storage Default
{
<Data name="RequestDefaultData1">
<Subscript>"Request1"</Subscript>
<Value name="1">
<Value>CustomerCode</Value>
</Value>
<Value name="2">
<Value>Pwd</Value>
</Value>
<Value name="3">
<Value>PrivateKey</Value>
</Value>
<Value name="4">
<Value>apiAccount</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
