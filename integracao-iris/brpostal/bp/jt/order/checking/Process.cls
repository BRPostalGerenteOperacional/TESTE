Class brpostal.bp.jt.order.checking.Process Extends brpostal.bp.jt.base.Process
{

Method OnRequest(pRequest As brpostal.bp.jt.msg.Request, Output pResponse As brpostal.bp.jt.msg.Response) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pResponse = ##Class(brpostal.bp.jt.msg.Response).%New()

        Set tDynamicObjectResponse = ##Class(%DynamicObject).%New()

        Set tRequestDiget = ##Class(brpostal.bo.jet.generateDigest.msg.Request).%New()

        Set tRequestDiget.CustomerCode  = pRequest.CustomerCode
        Set tRequestDiget.PrivateKey    = pRequest.PrivateKey
        Set tRequestDiget.Pwd           = pRequest.Pwd

        #Dim tResponseDiget As brpostal.bo.jet.generateDigest.msg.Response
        Set tSC = ..SendRequestSync("Generete Digest Operation", tRequestDiget, .tResponseDiget)
        $$$ThrowOnError(tSC)

        If (tResponseDiget.digest '="")
        {
            Set tDynamicObjectRequest   = ##Class(%DynamicObject).%FromJSON(pRequest.sendData.Contents.Read(pRequest.sendData.Contents.Size))

            Set tSerialNumber = ##Class(%DynamicArray).%New()

            Do tSerialNumber.%Push(tDynamicObjectRequest.tag)

            Set tCheckingOrder = ##Class(%DynamicObject).%New()

            Set tCheckingOrder.serialNumber         =  tSerialNumber
            Set tCheckingOrder.digest               =  tResponseDiget.digest
            Set tCheckingOrder.customerCode         =  pRequest.CustomerCode
            Set tCheckingOrder.command              =  2

            Set tJSON = tCheckingOrder.%ToJSON()

            Set tRequestDigetJSON = ##Class(brpostal.bo.jet.generateDigest.msg.RequestJSON).%New()

            Set tRequestDigetJSON.PrivateKey    = pRequest.PrivateKey
            Set tRequestDigetJSON.json          = tJSON

            #Dim tResponseDigetJSON As brpostal.bo.jet.generateDigest.msg.ResponseJSON
            Set tSC = ..SendRequestSync("Generete Digest Operation", tRequestDigetJSON, .tResponseDigetJSON)
            $$$ThrowOnError(tSC)

            Set tRequest    = ##Class(REST.bo.http.msg.Request).%New()
            
            Set tSendData    = ##Class(REST.vo.http.SendData).%New()

            Set tSendData.Server                    = ..Server	//"demoopenapi.jtjms-br.com"
            Set tSendData.Port					    = ..Port //443
            Set tSendData.Url					    = ..Url //"/webopenplatformapi/api/order/addOrder"
            Set tSendData.SSLCheckServerIdentity    = ..SSLCheckServerIdentity //1
            Set tSendData.SSL					    = ..SSLConfig //"HTTPS"
            Set tSendData.Type					    = ..TypeRest //"POST"
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

            Set tSC = ..CheckingOrderResponse(tResponse.returnData.StatusCode, tResponse.returnData.Contents, .tDynamicObjectResponse)
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

Method CheckingOrderResponse(pStatusCode As %String, pContents As %Stream.GlobalCharacter, ByRef pDynamicGenerate As %DynamicObject) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pDynamicGenerate = ##Class(%DynamicObject).%New()

        Set tDynamicResponse = ##Class(%DynamicObject).%FromJSON(pContents.Read(pContents.Size))
        
        If (tDynamicResponse.code = 1)
        {
            If (tDynamicResponse.data.%Size()>0)
            {
                Set tArrayObject = ##Class(%DynamicArray).%New()

                Set tInteratorValue= tDynamicResponse.data.%GetIterator()
                While ((tInteratorValue.%GetNext(.tKeyData, .tValueData)))
                {
                    Set tArrayItem = ##Class(%DynamicArray).%New()

                    Set tDynamicAddressFrom = ##Class(%DynamicObject).%New()

                    Set tDynamicAddressFrom.name			= tValueData.sender.name
                    Set tDynamicAddressFrom.phone			= tValueData.sender.phone
                    Set tDynamicAddressFrom.email			= tValueData.sender.mailBox
                    Set tDynamicAddressFrom.document		= tValueData.sender.taxNumber
                    Set tDynamicAddressFrom.street			= tValueData.sender.street
                    Set tDynamicAddressFrom.number			= tValueData.sender.streetNumber
                    Set tDynamicAddressFrom.complement		= tValueData.sender.address
                    Set tDynamicAddressFrom.neighborhood	= tValueData.sender.area
                    Set tDynamicAddressFrom.city			= tValueData.sender.city
                    Set tDynamicAddressFrom.uf				= tValueData.sender.prov
                    Set tDynamicAddressFrom.country			= "BR"
                    Set tDynamicAddressFrom.zipcode         = tValueData.sender.postCode
                    
                    Set tDynamicAddressTo = ##Class(%DynamicObject).%New()
                    
                    Set tDynamicAddressTo.name			    = tValueData.receiver.name
                    Set tDynamicAddressTo.phone			    = tValueData.receiver.phone
                    Set tDynamicAddressTo.document		    = tValueData.receiver.taxNumber
                    Set tDynamicAddressTo.street			= tValueData.receiver.street
                    Set tDynamicAddressTo.number			= tValueData.receiver.streetNumber
                    Set tDynamicAddressTo.complement		= tValueData.receiver.address
                    Set tDynamicAddressTo.neighborhood	    = tValueData.receiver.area
                    Set tDynamicAddressTo.city			    = tValueData.receiver.city
                    Set tDynamicAddressTo.uf				= tValueData.receiver.prov
                    Set tDynamicAddressTo.country			= "BR"
                    Set tDynamicAddressTo.zipcode           = tValueData.receiver.postCode
                    
                    Do tArrayItem.%Push(
                                {
                                    "amount":				(tValueData.itemsValue),
                                    "weight":				(tValueData.weight),
                                    "width":				(tValueData.width),
                                    "height":				(tValueData.height),
                                    "length":				(tValueData.length),
                                    "volume":				(tValueData.volume),
                                    "totalQuantity":		(tValueData.totalQuantity),
                                    "volume":				(tValueData.volume),
                                    "insurance_value":		(tValueData."insurance_value"),
                                    "priceCurrency":		(tValueData.priceCurrency),
                                    "address_from":			(tDynamicAddressFrom),
                                    "address_to":			(tDynamicAddressTo),		
                                    "creationDateTime":		(tDynamicResponse.data.createOrderTime)
                                }
                    )
                    
                    Do tArrayObject.%Push(
                        {
                            "shipmentId":		(tValueData.txlogisticId),
                            "tag":				(tValueData.billCode),
                            "tags":			    (tDynamicResponse.data.sortingCode),
                            "item":				(tArrayItem)
                        }
                    )  
                }

                Set pDynamicGenerate.object 	= tArrayObject 
            }
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
