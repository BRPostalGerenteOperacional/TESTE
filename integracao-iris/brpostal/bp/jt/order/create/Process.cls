Class brpostal.bp.jt.order.create.Process Extends brpostal.bp.jt.base.Process
{

Method OnRequest(pRequest As brpostal.bp.jt.msg.Request, Output pResponse As brpostal.bp.jt.msg.Response) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pResponse = ##Class(brpostal.bp.jt.msg.Response).%New()

        Set tRequestDiget = ##Class(brpostal.bo.jet.generateDigest.msg.Request).%New()

        Set tRequestDiget.CustomerCode  = pRequest.CustomerCode
        Set tRequestDiget.PrivateKey    = pRequest.PrivateKey
        Set tRequestDiget.Pwd           = pRequest.Pwd

        #Dim tResponseDiget As brpostal.bo.jet.generateDigest.msg.Response
        Set tSC = ..SendRequestSync("Generete Digest Operation", tRequestDiget, .tResponseDiget)
        $$$ThrowOnError(tSC)

        If (tResponseDiget.digest '="")
        {
            Set tJSON = $ZCONVERT(pRequest.sendData.Contents.Read(pRequest.sendData.Contents.Size),"I","UTF8")

            $$$LOGINFO("Request "_tJSON)

            Set tDynamicObjectRequest   = ##Class(%DynamicObject).%FromJSON(tJSON)

            Set tOrder = ##Class(%DynamicObject).%New()
        
            Set tOrder.customerCode         = pRequest.CustomerCode
            Set tOrder.digest               = tResponseDiget.digest
            Set tOrder.txlogisticId         = tDynamicObjectRequest.shipmentId
            Set tOrder.expressType          = tDynamicObjectRequest.serviceType
            Set tOrder.orderType            = "02"
            Set tOrder.serviceType          = "02"
            Set tOrder.deliveryType         = "03"
            Set tOrder.goodsType            = "bm000006"
            Set tOrder.length               = tDynamicObjectRequest.length
            Set tOrder.width                = tDynamicObjectRequest.width
            Set tOrder.height               = tDynamicObjectRequest.height
            Set tOrder.weight               = tDynamicObjectRequest.weight
            Set tOrder.totalQuantity        = "1"
            Set tOrder.invoiceNumber        = tDynamicObjectRequest.invoice.number
            Set tOrder.invoiceSerialNumber  = tDynamicObjectRequest.invoice.serialNumber
            Set tOrder.invoiceMoney         = tDynamicObjectRequest.invoice.value
            Set tOrder.taxCode              = tDynamicObjectRequest.invoice.requestCode
            Set tOrder.invoiceAccessKey     = tDynamicObjectRequest.invoice.key
            Set tOrder.invoiceIssueDate     = tDynamicObjectRequest.invoice.date
            Set tOrder.documentCteKey       = tDynamicObjectRequest.invoice.key

            Set tSenderOrder = ##Class(%DynamicObject).%New()

            If ($Length(tDynamicObjectRequest."address_to".document) > 11)
            {
                Set tDocumentAddressFrom = $Extract(tDynamicObjectRequest."address_to".document,1,2)_"."_$Extract(tDynamicObjectRequest."address_to".document,3,5)_"."_$Extract(tDynamicObjectRequest."address_to".document,6,9)_"/"_$Extract(tDynamicObjectRequest."address_to".document,10,12)_"-"_$Extract(tDynamicObjectRequest."address_to".document,13,14)
            }
            Else
            {
                Set tDocumentAddressFrom = $Extract(tDynamicObjectRequest."address_to".document,1,3)_"."_$Extract(tDynamicObjectRequest."address_to".document,4,6)_"."_$Extract(tDynamicObjectRequest."address_to".document,7,9)_"-"_$Extract(tDynamicObjectRequest."address_to".document,10,11)
            }

            Set tSenderOrder.name             = tDynamicObjectRequest."address_from".name
            Set tSenderOrder.postCode         = tDynamicObjectRequest."address_from".zipcode
            Set tSenderOrder.taxNumber        = tDocumentAddressFrom
            Set tSenderOrder.mobile           = tDynamicObjectRequest."address_from".phone
            Set tSenderOrder.phone            = tDynamicObjectRequest."address_from".phone
            Set tSenderOrder.prov             = tDynamicObjectRequest."address_from".state
            Set tSenderOrder.city             = tDynamicObjectRequest."address_from".city
            Set tSenderOrder.area             = tDynamicObjectRequest."address_from".neighborhood
            Set tSenderOrder.street           = tDynamicObjectRequest."address_from".street
            Set tSenderOrder.streetNumber     = tDynamicObjectRequest."address_from".number
            Set tSenderOrder.address          = tDynamicObjectRequest."address_from".street
            Set tSenderOrder.ieNumber         = tDynamicObjectRequest."address_from"."user_id"

            Set tOrder.sender           = tSenderOrder

            Set tReceiverOrder = ##Class(%DynamicObject).%New()

            If ($Length(tDynamicObjectRequest."address_from".document) > 11)
            {
                Set tDocumentAddressTo = $Extract(tDynamicObjectRequest."address_from".document,1,2)_"."_$Extract(tDynamicObjectRequest."address_from".document,3,5)_"."_$Extract(tDynamicObjectRequest."address_from".document,6,9)_"/"_$Extract(tDynamicObjectRequest."address_from".document,10,12)_"-"_$Extract(tDynamicObjectRequest."address_from".document,13,14)
            }
            Else
            {
                Set tDocumentAddressTo = $Extract(tDynamicObjectRequest."address_from".document,1,3)_"."_$Extract(tDynamicObjectRequest."address_from".document,4,6)_"."_$Extract(tDynamicObjectRequest."address_from".document,7,9)_"-"_$Extract(tDynamicObjectRequest."address_from".document,10,11)
            }

            Set tReceiverOrder.name           = tDynamicObjectRequest."address_to".name
            Set tReceiverOrder.company        = tDynamicObjectRequest."address_to".company
            Set tReceiverOrder.postCode       = tDynamicObjectRequest."address_to".zipcode
            Set tReceiverOrder.mailBox        = tDynamicObjectRequest."address_to".email
            Set tReceiverOrder.taxNumber      = tDocumentAddressTo
            Set tReceiverOrder.mobile         = tDynamicObjectRequest."address_to".phone
            Set tReceiverOrder.phone          = tDynamicObjectRequest."address_to".phone
            Set tReceiverOrder.prov           = tDynamicObjectRequest."address_to".state
            Set tReceiverOrder.city           = tDynamicObjectRequest."address_to".city
            Set tReceiverOrder.area           = tDynamicObjectRequest."address_to".neighborhood
            Set tReceiverOrder.street         = tDynamicObjectRequest."address_to".street
            Set tReceiverOrder.streetNumber   = tDynamicObjectRequest."address_to".number
            Set tReceiverOrder.address        = tDynamicObjectRequest."address_to".street
            Set tReceiverOrder.ieNumber       = tDynamicObjectRequest."address_to"."user_id"

            Set tOrder.receiver         = tReceiverOrder

            If (tDynamicObjectRequest.ncm'="")
            {
                Set tItemsOrder = ##Class(%DynamicObject).%New()

                Set tItemsOrder.itemNcm             = tDynamicObjectRequest.ncm

                Set tArrayItems = ##Class(%DynamicArray).%New()

                Do tArrayItems.%Push(tItemsOrder)

                Set tOrder.items    = tItemsOrder
            }

            Set tTranslateOrder = ##Class(%DynamicObject).%New()

            Set tTranslateOrder.name             = tDynamicObjectRequest."address_to".name
            Set tTranslateOrder.postCode         = tDynamicObjectRequest."address_to".zipcode
            Set tTranslateOrder.taxNumber        = tDocumentAddressTo
            Set tTranslateOrder.mobile           = tDynamicObjectRequest."address_to".phone
            Set tTranslateOrder.phone            = tDynamicObjectRequest."address_to".phone
            Set tTranslateOrder.prov             = tDynamicObjectRequest."address_to".state
            Set tTranslateOrder.city             = tDynamicObjectRequest."address_to".city
            Set tTranslateOrder.area             = tDynamicObjectRequest."address_to".neighborhood
            Set tTranslateOrder.street           = tDynamicObjectRequest."address_to".street
            Set tTranslateOrder.streetNumber     = tDynamicObjectRequest."address_to".number
            Set tTranslateOrder.address          = tDynamicObjectRequest."address_to".street
            Set tTranslateOrder.ieNumber         = tDynamicObjectRequest."address_to"."user_id"

            Set tOrder.translate        = tTranslateOrder

            Set tJSON = tOrder.%ToJSON()

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

            Set tSC = ..TrackOrderResponse(tResponse.returnData.StatusCode,tDynamicObjectRequest,tOrder,tResponse.returnData.Contents,.tDynamicObjectResponse)
            $$$ThrowOnError(tSC)
        }
        Else
        {
            Set tDynamicObjectResponse = ##Class(%DynamicObject).%New()

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

Method TrackOrderResponse(pCodeStatus As %String, pDynamicObjectRequest As %DynamicObject, pOrderGenerate As %DynamicObject, pContents As %Stream.GlobalCharacter, Output pDynamicGenerate As %DynamicObject) As %Status
{
    Set tSC = $$$OK

    Try
    {
        Set pDynamicGenerate = ##Class(%DynamicObject).%New()

        Set tDynamicResponse = ##Class(%DynamicObject).%FromJSON(pContents.Read(pContents.Size))
        
        If (tDynamicResponse.code = 1)
        {
            Set tDynamicService = ##Class(%DynamicObject).%New()
                
            Set tDynamicService.transporter	= pDynamicObjectRequest.service
            Set tDynamicService.service		= pDynamicObjectRequest.serviceType
            
            If (tDynamicResponse.data.orderList.%Size()>0)
            {
                Set tArrayObject = ##Class(%DynamicArray).%New()

                Set tInteratorValue= tDynamicResponse.data.orderList.%GetIterator()
                While ((tInteratorValue.%GetNext(.tKeyOrderList, .tValueOrderList)))
                {
                    Set tArrayItem = ##Class(%DynamicArray).%New()

                    Set tDynamicAddressFrom = ##Class(%DynamicObject).%New()

                    Set tDynamicAddressFrom.name			= pOrderGenerate.sender.name
                    Set tDynamicAddressFrom.phone			= pOrderGenerate.sender.phone
                    Set tDynamicAddressFrom.email			= pOrderGenerate.sender.mailBox
                    Set tDynamicAddressFrom.document		= pOrderGenerate.sender.taxNumber
                    Set tDynamicAddressFrom.street			= pOrderGenerate.sender.street
                    Set tDynamicAddressFrom.number			= pOrderGenerate.sender.streetNumber
                    Set tDynamicAddressFrom.complement		= pOrderGenerate.sender.address
                    Set tDynamicAddressFrom.neighborhood	= pOrderGenerate.sender.area
                    Set tDynamicAddressFrom.city			= pOrderGenerate.sender.city
                    Set tDynamicAddressFrom.uf				= pOrderGenerate.sender.prov
                    Set tDynamicAddressFrom.country			= "BR"
                    Set tDynamicAddressFrom.zipcode         = pOrderGenerate.sender.postCode
                    
                    Set tDynamicAddressTo = ##Class(%DynamicObject).%New()
                    
                    Set tDynamicAddressTo.name			    = pOrderGenerate.receiver.name
                    Set tDynamicAddressTo.phone			    = pOrderGenerate.receiver.phone
                    Set tDynamicAddressTo.document		    = pOrderGenerate.receiver.taxNumber
                    Set tDynamicAddressTo.street			= pOrderGenerate.receiver.street
                    Set tDynamicAddressTo.number			= pOrderGenerate.receiver.streetNumber
                    Set tDynamicAddressTo.complement		= pOrderGenerate.receiver.address
                    Set tDynamicAddressTo.neighborhood	    = pOrderGenerate.receiver.area
                    Set tDynamicAddressTo.city			    = pOrderGenerate.receiver.city
                    Set tDynamicAddressTo.uf				= pOrderGenerate.receiver.prov
                    Set tDynamicAddressTo.country			= "BR"
                    Set tDynamicAddressTo.zipcode           = pOrderGenerate.receiver.postCode
                    
                    Do tArrayItem.%Push(
                                {
                                    "amount":				(pOrderGenerate.itemsValue),
                                    "weight":				(pOrderGenerate.weight),
                                    "width":				(pOrderGenerate.width),
                                    "height":				(pOrderGenerate.height),
                                    "length":				(pOrderGenerate.length),
                                    "volume":				(pOrderGenerate.volume),
                                    "totalQuantity":		(pOrderGenerate.totalQuantity),
                                    "insurance_value":		(pOrderGenerate."insurance_value"),
                                    "priceCurrency":		(pOrderGenerate.priceCurrency),
                                    "address_from":			(tDynamicAddressFrom),
                                    "address_to":			(tDynamicAddressTo),		
                                    "creationDateTime":		(tDynamicResponse.data.createOrderTime)
                                }
                    )
                    
                    Do tArrayObject.%Push(
                        {
                            "shipmentId":		(tValueOrderList.txlogisticId),
                            "orderId":			(pDynamicObjectRequest.orderId),
                            "tag":				(tValueOrderList.billCode),
                            "plpId":			(tDynamicResponse.data.sortingCode),
                            "service":			(tDynamicService),
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
                "codeMessage":	    (pCodeStatus),
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
