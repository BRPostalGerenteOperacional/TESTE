Class brpostal.bp.jt.signature.JT Extends brpostal.bp.jt.base.Process
{

Method OnRequest(pRequest As brpostal.bp.jt.signature.msg.Request, Output pResponse As brpostal.bp.jt.signature.msg.Response) As %Status
{
    Set tResponse = ##Class(brpostal.bp.jt.signature.msg.Response).%New()

    Set tCustomerCode   = ..CustomerCode
    Set tPwd            = ..Pwd
    Set tPrivateKey     = ..PrivateKey

    Set tMD5 = ##class(%SYSTEM.Encryption).MD5Hash(tCustomerCode_tPwd_tPrivateKey)

    $$$LOGINFO("1 MD5 "_tMD5)

    Set tDigest = ##Class(%SYSTEM.Encryption).Base64Encode(tMD5)
    
    $$$LOGINFO("1 Digest "_tDigest)
    
    Set tJSON = pRequest.JSON
    				
    $$$LOGINFO("JSON "_tJSON)
    				
    Set tMD5 = ##class(%SYSTEM.Encryption).MD5Hash(tJSON_tPrivateKey)

    $$$LOGINFO("2 MD5 "_tMD5)

    Set tDigest = ##Class(%SYSTEM.Encryption).Base64Encode(tMD5)
    
    $$$LOGINFO("2 Digest "_tDigest)
	
	Set tSendData    = ##Class(REST.vo.http.SendData).%New()

	Set tSendData.Server                    = ..Server	//"demoopenapi.jtjms-br.com"
	Set tSendData.Port					    = ..Port //443
	Set tSendData.Url					    = ..Url //"/webopenplatformapi/api/order/addOrder"
	Set tSendData.SSLCheckServerIdentity    = ..SSLCheckServerIdentity //1
	Set tSendData.SSL					    = ..SSLConfig //"HTTPS"
	Set tSendData.Type					    = ..TypeRest //"POST"
    Set tTimeStamp                          = $SYSTEM.SYS.TimeStamp()

    Do tSendData.Headers.Insert("content-type;"_..ContentType)
	Do tSendData.Headers.Insert("timestamp;"_tTimeStamp)
	Do tSendData.Headers.Insert("apiAccount;"_..apiAccount)
	
	Do tSendData.FormEncoded.SetAt("bizContent",tJSON)
	
    Set tResponse.digest        = _tDigest
    Set tResponse.bizContent    = tJSON
    Set tResponse.contentType   = ..ContentType
    Set tResponse.timeStamp     = tTimeStamp
    Set tResponse.sendData      = tSendData

    Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
