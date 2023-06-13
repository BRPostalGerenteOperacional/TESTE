Class brpostal.bp.jt.logisticsTrajectory.track.Process Extends brpostal.bp.jt.base.Process
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
            
            Set tDynamicObjectRequest   = ##Class(%DynamicObject).%FromJSON(pRequest.sendData.Contents.Read(pRequest.sendData.Contents.Size))

            Set tTrack = ##Class(%DynamicObject).%New()

            If (tDynamicObjectRequest.tags.%Size() > 0)
            {
                Set tTags = ""
                Set tInteratorValue = tDynamicObjectRequest.tags.%GetIterator()
                While ((tInteratorValue.%GetNext(.tKeyTags, .tValueTags)))
                {
                    If (tTags="")
                    {
                        Set tTags = tValueTags.tag
                    }
                    Else
                    {
                        Set tTags = tTags_","_tValueTags.tag
                    }
                }

                Set tTrack.billCodes    = tTags

                Set tJSON = tTrack.%ToJSON()

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

                Set tSC = ..TrackResponse(tResponse.returnData.StatusCode,tResponse.returnData.Contents,.tDynamicObjectResponse)
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
                        "codeMessage":	    ("No tags found"),
                        "sessionId":		(..%SessionId)
                    }
                )
            
                Set tDynamicObjectResponse.answer		= tArrayAnswer
            }
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

Method TrackResponse(pStatusCode As %String, pContents As %Stream.GlobalCharacter, Output pDynamicGenerate As %DynamicObject) As %Status
{
    Set tSC = $$$OK
    
    Try
    {
        Set pDynamicGenerate = ##Class(%DynamicObject).%New()

        Set tDynamicResponse = ##Class(%DynamicObject).%FromJSON(pContents.Read(pContents.Size))
        
        If (tDynamicResponse.code = 1)
        {
            If (tDynamicResponse.data.%Size() > 0) 
            {
                Set tArrayObject = ##Class(%DynamicArray).%New()

                Set tInteratorValue= tDynamicResponse.data.%GetIterator()
                While ((tInteratorValue.%GetNext(.tKeyData, .tValueData)))
                {
                    Set tArrayDetail = ##Class(%DynamicArray).%New()
                    
                    If (tValueData.details.%Size()>0)
                    {
                        Set tInteratorValue = tValueData.details.%GetIterator()
                        While ((tInteratorValue.%GetNext(.tKeyDetails, .tValueDetails)))
                        {
                            Do tArrayDetail.%Push(
                                {
                                    "tag":          (tValueDetails.billCode),
                                    "updateData":   (tValueDetails.scanTime),
                                    "detail":       (tValueDetails.desc),
                                    "type":         (tValueDetails.scanType)
                                }
                            )
                        }
                    }

                    Do tArrayObject.%Push(
                        {
                            "tag":              (tValueData.billCode),
                            "tracking":         (tArrayDetail)
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
