Class REST.bp.http.msg.Response Extends Ens.Response
{

Property ReturnData As REST.vo.http.returnData;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>ReturnData</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
