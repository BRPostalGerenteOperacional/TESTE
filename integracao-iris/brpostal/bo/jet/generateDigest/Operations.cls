Class brpostal.bo.jet.generateDigest.Operations Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Property FlagPwdHash As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "FlagPwdHash:J&T Config";

Method GenerateDigetParameter(pRequest As brpostal.bo.jet.generateDigest.msg.Request, Output pResponse As brpostal.bo.jet.generateDigest.msg.Response) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pResponse = ##Class(brpostal.bo.jet.generateDigest.msg.Response).%New()

        If (..FlagPwdHash=1)
        {
            Set pRequest.Pwd = $ZCONVERT(##class(%SYSTEM.Encryption).MD5Hash(pRequest.Pwd_"jadada236t2"),"U")
            $$$LOGINFO("Pwd MD5 "_pRequest.Pwd)
        }

        Set tMD5 = ##class(%SYSTEM.Encryption).MD5Hash(pRequest.CustomerCode_pRequest.Pwd_pRequest.PrivateKey)

        $$$LOGINFO("MD5 "_tMD5)

        Set tDigest = ##Class(%SYSTEM.Encryption).Base64Encode(tMD5)
        
        $$$LOGINFO("Digest "_tDigest)

        Set pResponse.digest = tDigest
    }
    Catch(tException)
    {
        If ('$System.Status.IsError(tSC))
		{
			Set tSC = tException.AsStatus()
		}
    }

    Quit tSC
}

Method GenerateDigetJSON(pRequest As brpostal.bo.jet.generateDigest.msg.RequestJSON, Output pResponse As brpostal.bo.jet.generateDigest.msg.ResponseJSON) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pResponse = ##Class(brpostal.bo.jet.generateDigest.msg.ResponseJSON).%New()

        Set tMD5 = ##class(%SYSTEM.Encryption).MD5Hash(pRequest.json_pRequest.PrivateKey)

        $$$LOGINFO("MD5 "_tMD5)

        Set tDigest = ##Class(%SYSTEM.Encryption).Base64Encode(tMD5)
        
        $$$LOGINFO("Digest "_tDigest)

        Set pResponse.digest = tDigest
    }
    Catch(tException)
    {
        If ('$System.Status.IsError(tSC))
		{
			Set tSC = tException.AsStatus()
		}
    }

    Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="brpostal.bo.jet.generateDigest.msg.Request"> 
		<Method>GenerateDigetParameter</Method>
	</MapItem>
    <MapItem MessageType="brpostal.bo.jet.generateDigest.msg.RequestJSON"> 
		<Method>GenerateDigetJSON</Method>
	</MapItem>	
</MapItems>
}

}
