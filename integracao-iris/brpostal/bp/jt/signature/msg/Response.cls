Class brpostal.bp.jt.signature.msg.Response Extends Ens.Response
{

Property digest As %String(MAXLEN = "");

Property bizContent As %String(MAXLEN = "");

Property contentType As %String(MAXLEN = 15);

Property timeStamp As %String(MAXLEN = 50);

Property sendData As REST.vo.http.SendData;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>digest</Value>
</Value>
<Value name="2">
<Value>bizContent</Value>
</Value>
<Value name="3">
<Value>contentType</Value>
</Value>
<Value name="4">
<Value>timeStamp</Value>
</Value>
<Value name="5">
<Value>sendData</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
