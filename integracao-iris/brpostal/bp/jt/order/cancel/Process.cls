Class brpostal.bp.jt.order.cancel.Process Extends brpostal.bp.jt.base.Process
{

Method OnRequest(pRequest As brpostal.bp.jt.msg.Request, Output pResponse As brpostal.bp.jt.msg.Response) As %Status
{
    Set tSC = $$$OK
    Set pResponse = ##Class(brpostal.bp.jt.msg.Response).%New()

    Try
    {
        Set tDynamicObjectResponse = ##Class(%DynamicObject).%New()

        Set tDynamicObjectRequest   = ##Class(%DynamicObject).%FromJSON(pRequest.sendData.Contents.Read(pRequest.sendData.Contents.Size))

        If (tDynamicObjectRequest.cancel = 1)
        {
            Set tRequestDiget = ##Class(brpostal.bo.jet.generateDigest.msg.Request).%New()

            Set tRequestDiget.CustomerCode  = pRequest.CustomerCode
            Set tRequestDiget.PrivateKey    = pRequest.PrivateKey
            Set tRequestDiget.Pwd           = pRequest.Pwd

            #Dim tResponseDiget As brpostal.bo.jet.generateDigest.msg.Response
            Set tSC = ..SendRequestSync("Generete Digest Operation", tRequestDiget, .tResponseDiget)
            $$$ThrowOnError(tSC)

            If (tResponseDiget.digest '="")
            {
                Set tCancelOrder = ##Class(%DynamicObject).%New()

                Set tCancelOrder.customerCode   = pRequest.CustomerCode
                Set tCancelOrder.digest         = tResponseDiget.digest
                Set tCancelOrder.orderType      = 1
                Set tCancelOrder.txlogisticId   = tDynamicObjectRequest.txlogisticId
                Set tCancelOrder.reason         = tDynamicObjectRequest.tag

                Set tJSON = tCancelOrder.%ToJSON()

                Set tRequestDigetJSON = ##Class(brpostal.bo.jet.generateDigest.msg.RequestJSON).%New()

                Set tRequestDigetJSON.PrivateKey    = pRequest.PrivateKey
                Set tRequestDigetJSON.json          = tJSON

                #Dim tResponseDigetJSON As brpostal.bo.jet.generateDigest.msg.ResponseJSON
                Set tSC = ..SendRequestSync("Generete Digest Operation", tRequestDigetJSON, .tResponseDigetJSON)
                $$$ThrowOnError(tSC)

                Set tRequest    = ##Class(REST.bo.http.msg.Request).%New()
                
                Set tSendData    = ##Class(REST.vo.http.SendData).%New()

                Set tSendData.Server                    = ..Server
                Set tSendData.Port					    = ..Port
                Set tSendData.Url					    = ..Url
                Set tSendData.SSLCheckServerIdentity    = ..SSLCheckServerIdentity
                Set tSendData.SSL					    = ..SSLConfig
                Set tSendData.Type					    = ..TypeRest
                Set tTimeStamp                          = $TRANSLATE($PIECE($ZDATETIME($ZTIMESTAMP,3,1,3),".",1),"/: -","")
                
                Do tSendData.Headers.Insert("Content-Type;"_..ContentType)
                Do tSendData.Headers.Insert("apiAccount;"_pRequest.apiAccount)
                Do tSendData.Headers.Insert("digest;"_tResponseDigetJSON.digest)
                Do tSendData.Headers.Insert("timestamp;"_tTimeStamp)
                
                Do tSendData.FormEncoded.Insert("bizContent;"_tJSON)
                
                Set tRequest.sendData   = tSendData

                #Dim tResponse As REST.bo.http.msg.Response
                Set tSC = ..SendRequestSync("HTTPs Custom Operation", tRequest, .tResponse)
                $$$ThrowOnError(tSC)

                Set tSC = ..CancelOrderResponse(tResponse.returnData.StatusCode,
                                tDynamicObjectRequest.shipmentId,
                                tDynamicObjectRequest.orderId,
                                tResponse.returnData.Contents,
                                .tDynamicObjectResponse)
                $$$ThrowOnError(tSC)
            }
            Else
            {
                Set tArrayAnswer = ##Class(%DynamicArray).%New()
                
                Do tArrayAnswer.%Push(
                    {
                        "status":			(0),
                        "mensagem":			("fail"),
                        "codeMessage":	    ("It was not possible to generate diget"),
                        "sessionId":		(..%SessionId)
                    }
                )
            
                Set tDynamicObjectResponse.answer		= tArrayAnswer
            }

            Set pResponse.returnData        = tResponse.returnData
        }
        Else
        {
            Set tArrayAnswer = ##Class(%DynamicArray).%New()
                
                Do tArrayAnswer.%Push(
                    {
                        "status":			(0),
                        "mensagem":			("fail"),
                        "codeMessage":	    ("Canceled flag not flagged"),
                        "sessionId":		(..%SessionId)
                    }
                )
            
                Set tDynamicObjectResponse.answer		= tArrayAnswer
        }

        Set pResponse.transformedJson   = tDynamicObjectResponse.%ToJSON()
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

Method CancelOrderResponse(pStatusCode As %String, pShipmentId As %String, pOrderId As %String, pDynamicResponse As %Stream.GlobalCharacter, ByRef pDynamicGenerate As %DynamicObject) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pDynamicGenerate = ##Class(%DynamicObject).%New()

        Set tDynamicResponse = ##Class(%DynamicObject).%FromJSON(pDynamicResponse.Read(pDynamicResponse.Size))
        
        If (tDynamicResponse.code = 1)
        {
            Set tArrayObject = ##Class(%DynamicArray).%New()

            Do tArrayObject.%Push(
                {
                    "shipmentId":		(pShipmentId),
                    "orderId":			(pOrderId),
                    "tag":              (tDynamicResponse.data.billCode),
                    "external_id":      (tDynamicResponse.txlogisticId)
                }
            )

            Set pDynamicGenerate.object 	= tArrayObject
        }
        
        Set tArrayAnswer = ##Class(%DynamicArray).%New()
            
        Do tArrayAnswer.%Push(
            {
                "status":			(tDynamicResponse.code),
                "mensagem":			(tDynamicResponse.msg),
                "codeMessage":	    (pStatusCode),
                "sessionId":		(..%SessionId)
            }
        )
        
        Set pDynamicGenerate.answer		= tArrayAnswer
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
Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
