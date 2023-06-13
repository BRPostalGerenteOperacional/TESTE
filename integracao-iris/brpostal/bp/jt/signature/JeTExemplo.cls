/// Description
Class brpostal.bp.jt.signature.JeTExemplo Extends Ens.BusinessProcess
{

Property Server As %String(MAXLEN = 100);

Property Port As %Integer;

Property Url As %String(MAXLEN = 100);

Property SSLCheckServerIdentity As %Boolean;

Property SSLConfig As %String;

Property TypeRest As %String;

Parameter SETTINGS = "Server:Rest Config,Port:Rest Config,Url:Rest Config,SSLCheckServerIdentity:Rest Config,SSLConfig:Rest Config:sslConfigSelector,TypeRest:Rest Config";

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
    Set tCustomerCode   = "J0086024276"
    Set tPwd            = "64771DDF2697451085CBF0A65EA44949"
    Set tPrivateKey     = "a0a1047cce70493c9d5d29704f05d0d9"

    Set tMD5 = ##class(%SYSTEM.Encryption).MD5Hash(tCustomerCode_tPwd_tPrivateKey)

    $$$LOGINFO("1 MD5 "_tMD5)

    Set tDigest = ##Class(%SYSTEM.Encryption).Base64Encode(tMD5)
    
    $$$LOGINFO("1 Digest "_tDigest)
    
    Set tDynamicObject = ##Class(%DynamicObject).%New()
    
    Set tDynamicObject.customerCode = tCustomerCode
    Set tDynamicObject.digest		= tDigest
    Set tDynamicObject.txlogisticId	= "10000000001299"
    Set tDynamicObject.reason		= "YL1234567890123"
    
    Set tJSON = tDynamicObject.%ToJSON()
    				
    $$$LOGINFO("JSON "_tJSON)
    				
    Set tMD5 = ##class(%SYSTEM.Encryption).MD5Hash(tJSON_tPrivateKey)

    $$$LOGINFO("2 MD5 "_tMD5)

    Set tDigest = ##Class(%SYSTEM.Encryption).Base64Encode(tMD5)
    
    $$$LOGINFO("2 Digest "_tDigest)
	
	//Set tRequest = ##class(brpostal.bo.http.msg.Request).%New()
    Set tRequest    = ##Class(REST.bo.http.msg.Request).%New()
	
    Set tSendData    = ##Class(REST.vo.http.SendData).%New()

	Set tSendData.Server                    = ..Server	//"demoopenapi.jtjms-br.com"
	Set tSendData.Port					    = ..Port //443
	Set tSendData.Url					    = ..Url //"/webopenplatformapi/api/order/addOrder"
	Set tSendData.SSLCheckServerIdentity    = ..SSLCheckServerIdentity //1
	Set tSendData.SSL					    = ..SSLConfig //"HTTPS"
	Set tSendData.Type					    = ..TypeRest //"POST"
	
    Do tSendData.Headers.Insert("content-type;application/x-www-form-urlencoded")
	Do tSendData.Headers.Insert("timestamp;1565238848921")
	Do tSendData.Headers.Insert("apiAccount;292508153084379141")
	
	Do tSendData.FormEncoded.SetAt("bizContent",tJSON)
	
    Set tRequest.SendData   = tSendData

	#Dim tResponse As REST.bo.http.msg.Response
	Set tSC = ..SendRequestSync("HTTPs Custom Operation", tRequest, .tResponse)
	If ($System.Status.IsError(tSC))
	{
		Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}

    Quit $$$OK
}

/// Handle a 'Response'
Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
	// Subclass responsibility
	Quit $$$OK
}

Storage Default
{
<Data name="JTDefaultData">
<Subscript>"JT"</Subscript>
<Value name="1">
<Value>Server</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>Url</Value>
</Value>
<Value name="4">
<Value>SSLCheckServerIdentity</Value>
</Value>
<Value name="5">
<Value>SSLConfig</Value>
</Value>
<Value name="6">
<Value>TypeRest</Value>
</Value>
</Data>
<DefaultData>JTDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
