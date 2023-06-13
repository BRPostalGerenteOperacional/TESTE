Class brpostal.bs.rest.jt.HTTPService Extends EnsLib.REST.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Property CustomerCode As %String(MAXLEN = 40) [ InitialExpression = "J0086024276" ];

Property PWD As %String(MAXLEN = 40) [ InitialExpression = "64771DDF2697451085CBF0A65EA44949" ];

Property PrivateKey As %String(MAXLEN = 40) [ InitialExpression = "a0a1047cce70493c9d5d29704f05d0d9" ];

Property apiAccount As %String(MAXLEN = 50) [ InitialExpression = "292508153084379141" ];

Property JwtMoker As %String(MAXLEN = "");

Property FlagPRD As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "CustomerCode:J&T Config,PWD:J&T Config,PrivateKey:J&T Config,apiAccount:J&T Config,JwtMoker:J&T Config,FlagPRD:J&T Config";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<!--<Route Url="/token/generate" Method="" Call="TokenGenerate" /-->
    
	<Route Url="/api/jt/order/addOrder"				Method="POST"       Call="AddOrder" />
    <Route Url="/api/jt/order/getOrders"			Method="GET"       	Call="GetOrders" />
    <Route Url="/api/jt/order/cancelOrder"			Method="DELETE"		Call="CancelOrder" />
	<Route Url="/api/jt/logistics/trace"			Method="POST"     	Call="LogisticsTrackQuery" />
	<Route Url="/api/jt/mocker/create"				Method="POST"       Call="MockerCreate" />
	<Route Url="/api/jt/mocker/trace/:tag"			Method="GET"        Call="MockerTrace" />
</Routes>
}

Method AddOrder(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	
	Set pOutput.Attributes("Content-Type") = "application/json"
	
	Try
	{
		Set tAuthorization = $Get(pInput.Attributes("authorization"))
		If ($Piece(tAuthorization,"Bearer ",2) = ..JwtMoker)
		{
			If (pInput.Size > 10)
			{
				$$$LOGINFO("JSON RESQUEST")
				$$$LOGINFO(pInput.Read(pInput.Size))

				Do pInput.Rewind()

				Set tRequest = ##Class(brpostal.bp.jt.msg.Request).%New()

				Set tRequest.CustomerCode		= ..CustomerCode
				Set tRequest.PrivateKey			= ..PrivateKey
				Set tRequest.Pwd				= ..PWD
				Set tRequest.apiAccount			= ..apiAccount

				Set tSendData = ##Class(REST.vo.http.SendData).%New()
				
				Do tSendData.Contents.CopyFrom(pInput)
				Set tSendData.Type				= $Get(pInput.Attributes("HttpRequest"))

				Set tRequest.sendData			= tSendData

				#Dim tResponse As brpostal.bp.jt.msg.Response

				If (..FlagPRD = 0)
				{
					Set tSC = ..SendRequestSync("J&T Create Order Process", tRequest, .tResponse)
				}
				Else
				{
					Set tSC = ..SendRequestSync("J&T PROD Create Order Process", tRequest, .tResponse)
				}
				$$$ThrowOnError(tSC)

				$$$LOGINFO("JSON RESPONSE")
				$$$LOGINFO(tResponse.transformedJson)

				Do pOutput.Write(tResponse.transformedJson)

				Set pOutput.Attributes("ResponseCode") = tResponse.returnData.StatusCode
			}
			Else
			{
				Set pOutput.Attributes("ResponseCode") = ..#HTTP400BADREQUEST
			}
		}
		Else
		{
			Set pOutput.Attributes("ResponseCode") = ..#HTTP401UNAUTHORIZED
		}
	}
	Catch (tException)
	{
		Set tSC =  $System.Status.GetErrorText(tException.AsStatus())
		
		Set tBodyData = tException.Data
		Set tBodyData = $ZCONVERT(tBodyData,"O","UTF8")

		Set pOutput.Attributes("ResponseCode") =  ..#HTTP500INTERNALSERVERERROR
		
		Do pOutput.Write(tBodyData)
	}

	Quit $$$OK
}

Method GetOrders(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	Set pOutput.Attributes("Content-Type") = "application/json"
	
	Try
	{
		Set tAuthorization = $Get(pInput.Attributes("authorization"))
		If ($Piece(tAuthorization,"Bearer ",2) = ..JwtMoker)
		{
			Set tArray = ##class(%ArrayOfDataTypes).%New()
			
			Set tParams = $Get(pInput.Attributes("RawParams"))
			
			For i=1:1:$Length(tParams,"&")
			{
				Set tParam = $Piece(tParams,"&",i)
				Do tArray.SetAt($Piece(tParam,"=",2),$Piece(tParam,"=",1))
				
			}
			
			If (tArray.Count() > 0)
			{
				Set tSC = ##class(Ens.Util.JSON).ObjectToJSONStream(tArray,.tEntity)
				$$$ThrowOnError(tSC)

				$$$LOGINFO("JSON RESQUEST")
				$$$LOGINFO(tEntity.Read(tEntity.Size))
				
				Do tEntity.Rewind()

				Set tRequest = ##Class(brpostal.bp.jt.msg.Request).%New()

				Set tRequest.CustomerCode		= ..CustomerCode
				Set tRequest.PrivateKey			= ..PrivateKey
				Set tRequest.Pwd				= ..PWD
				Set tRequest.apiAccount			= ..apiAccount

				Set tSendData = ##Class(REST.vo.http.SendData).%New()

				Set tSendData.Contents			= tEntity.%ConstructClone(1)
				Set tSendData.Type				= pInput.Attributes("HttpRequest")

				Set tRequest.sendData			= tSendData

				#Dim tResponse As brpostal.bp.jt.msg.Response
				If (..FlagPRD = 0)
				{
					Set tSC = ..SendRequestSync("J&T Checking Order Process", tRequest, .tResponse)
				}
				Else
				{
					Set tSC = ..SendRequestSync("J&T PROD Checking Order Process", tRequest, .tResponse)
				}
				$$$ThrowOnError(tSC)

				$$$LOGINFO("JSON RESPONSE")
				$$$LOGINFO(tResponse.transformedJson)

				Do pOutput.Write(tResponse.transformedJson)

				Set pOutput.Attributes("ResponseCode") = tResponse.returnData.StatusCode
			}
			Else
			{
				Set pOutput.Attributes("ResponseCode") = ..#HTTP400BADREQUEST
			}
		}
		Else
		{
			Set pOutput.Attributes("ResponseCode") = ..#HTTP401UNAUTHORIZED
		}
	}
	Catch (tException)
	{
		Set tSC =  $System.Status.GetErrorText(tException.AsStatus())
		
		Set tBodyData = tException.Data
		Set tBodyData = $ZCONVERT(tBodyData,"O","UTF8")

		Set pOutput.Attributes("ResponseCode") =  ..#HTTP500INTERNALSERVERERROR
		
		Do pOutput.Write(tBodyData)
	}

	Quit $$$OK
}

Method CancelOrder(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	Set pOutput.Attributes("Content-Type") = "application/json"
	
	Try
	{
		Set tAuthorization = $Get(pInput.Attributes("authorization"))
		If ($Piece(tAuthorization,"Bearer ",2) = ..JwtMoker)
		{
			If (pInput.Size > 10)
			{
				$$$LOGINFO("JSON RESQUEST")
				$$$LOGINFO(pInput.Read(pInput.Size))

				Do pInput.Rewind()

				Set tRequest = ##Class(brpostal.bp.jt.msg.Request).%New()

				Set tRequest.CustomerCode		= ..CustomerCode
				Set tRequest.PrivateKey			= ..PrivateKey
				Set tRequest.Pwd				= ..PWD
				Set tRequest.apiAccount			= ..apiAccount

				Set tSendData = ##Class(REST.vo.http.SendData).%New()

				Do tSendData.Contents.CopyFrom(pInput)
				Set tSendData.Type				= pInput.Attributes("HttpRequest")

				Set tRequest.sendData			= tSendData

				#Dim tResponse As brpostal.bp.jt.msg.Response
				If (..FlagPRD = 0)
				{
					Set tSC = ..SendRequestSync("J&T Cancel Order Process", tRequest, .tResponse)
				}
				Else
				{
					Set tSC = ..SendRequestSync("J&T PROD Cancel Order Process", tRequest, .tResponse)
				}
				$$$ThrowOnError(tSC)

				$$$LOGINFO("JSON RESPONSE")
				$$$LOGINFO(tResponse.transformedJson)

				Do pOutput.Write(tResponse.transformedJson)
				
				If (tResponse.returnData.StatusLine'="")
				{
					Set pOutput.Attributes("ResponseCode") = tResponse.returnData.StatusCode
				}
				Else
				{
					Set pOutput.Attributes("ResponseCode") = ..#HTTP400BADREQUEST
				}
			}
			Else
			{
				Set pOutput.Attributes("ResponseCode") = ..#HTTP400BADREQUEST
			}
		}
		Else
		{
			Set pOutput.Attributes("ResponseCode") = ..#HTTP401UNAUTHORIZED
		}
	}
	Catch (tException)
	{
		If ('$$$ISERR(tSC))
		{
			Set tSC			= $System.Status.GetErrorText(tException.AsStatus())
			Set tBodyData	= tException.Data
		}
		Else
		{
			Set tBodyData	= $System.Status.GetErrorText(tSC)
		}

		Set pOutput.Attributes("ResponseCode") =  ..#HTTP500INTERNALSERVERERROR
		
		Do pOutput.Write(tBodyData)
	}

	Quit $$$OK
}

Method LogisticsTrackQuery(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	
	Set pOutput.Attributes("Content-Type") = "application/json"
	
	Try
	{
		$$$LOGINFO("ACESSOU")
		Set tAuthorization = $Get(pInput.Attributes("authorization"))
		If ($Piece(tAuthorization,"Bearer ",2) = ..JwtMoker)
		{
			If (pInput.Size > 10)
			{
				$$$LOGINFO("JSON RESQUEST")
				$$$LOGINFO(pInput.Read(pInput.Size))

				Do pInput.Rewind()

				Set tRequest = ##Class(brpostal.bp.jt.msg.Request).%New()

				Set tRequest.CustomerCode		= ..CustomerCode
				Set tRequest.PrivateKey			= ..PrivateKey
				Set tRequest.Pwd				= ..PWD
				Set tRequest.apiAccount			= ..apiAccount

				Set tSendData = ##Class(REST.vo.http.SendData).%New()
				
				Do tSendData.Contents.CopyFrom(pInput)
				Set tSendData.Type				= $Get(pInput.Attributes("HttpRequest"))

				Set tRequest.sendData			= tSendData

				#Dim tResponse As brpostal.bp.jt.msg.Response
				If (..FlagPRD = 0)
				{
					Set tSC = ..SendRequestSync("J&T Track Logistics Trajectory Process", tRequest, .tResponse)
				}
				Else
				{
					Set tSC = ..SendRequestSync("J&T PROD Track Logistics Trajectory Process", tRequest, .tResponse)
				}
				$$$ThrowOnError(tSC)

				$$$LOGINFO("JSON RESPONSE")
				$$$LOGINFO(tResponse.transformedJson)

				Do pOutput.Write(tResponse.transformedJson)

				Set pOutput.Attributes("ResponseCode") = tResponse.returnData.StatusCode
			}
			Else
			{
				Set pOutput.Attributes("ResponseCode") = ..#HTTP400BADREQUEST
			}
		}
		Else
		{
			Set pOutput.Attributes("ResponseCode") = ..#HTTP401UNAUTHORIZED
		}
	}
	Catch (tException)
	{
		Set tSC =  $System.Status.GetErrorText(tException.AsStatus())
		
		Set tBodyData = tException.Data
		Set tBodyData = $ZCONVERT(tBodyData,"O","UTF8")

		Set pOutput.Attributes("ResponseCode") =  ..#HTTP500INTERNALSERVERERROR
		
		Do pOutput.Write(tBodyData)
	}

	Quit $$$OK
}

}
