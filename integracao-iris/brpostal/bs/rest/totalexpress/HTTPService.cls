Class brpostal.bs.rest.totalexpress.HTTPService Extends EnsLib.REST.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Property CustomerCode As %String(MAXLEN = 100);

Property PWD As %String(MAXLEN = 100);

Property PrivateKey As %String(MAXLEN = 100);

Parameter SETTINGS = "CustomerCide:J&T Configuration,PWD:J&T Configuration,PrivateKey:J&T Configuration";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <!--Route Url="/api/jt/create"               		Method="POST"       Call="CreateTrackingJT" />
    
	<Route Url="/api/jt/order/addOrder"             Method=""       Call="CreateOrder" />
    <Route Url="/api/jt/order/getOrder"             Method=""       Call="CheckingOrder" />
    <Route Url="/api/jt/order/cancelOrder"          Method=""       Call="CancelOrder" />
    <Route Url="/api/jt/order/status"               Method=""       Call="OrderStatusReturn" />


    <Route Url="/api/jt/logistics/trace"            Method=""       Call="LogisticsTrackQuery" />
    <Route Url="/api/jt/trace/subscribe"            Method=""       Call="LogisticsTrackCubscription" />
    <Route Url="/api/jt/logistics/trajectory"       Method=""       Call="LogisticsTrajectoryReturn" /-->
    
     <Route Url="/api/totalexpress/mocker/create"             Method="POST"       Call="MockerCreate" />
     <Route Url="/api/totalexpress/trace/:tag"              Method="GET"        Call="MockerTrace" />
</Routes>
}

Method MockerCreate(pInput As %Stream.GlobalCharacter, Output pOutput As %Stream.GlobalCharacter) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	
	Try
	{
		Set tJSONRequest = ""
		While ('pInput.AtEnd)
		{
			Set tJSONRequest = tJSONRequest_pInput.Read()
		}
		
		$$$LOGINFO(tJSONRequest)
		
		If (tJSONRequest = "")
		{
			//Do pOutput.A
			Set pOutput.Attributes("ResponseCode") = "204 No Content"
			//Set tSC = $$$ERROR("204 No Content")
		}
		Else
		{
				
			Set tDynamicResponse = ##Class(%DynamicObject).%New()
			
			Set tArrayItem = ##Class(%DynamicArray).%New()
			
			Set tDynamicAddressFrom = ##Class(%DynamicObject).%New()
			
			Set tDynamicAddressFrom.name			= "Andreia From"
			Set tDynamicAddressFrom.phone			= "5511999999999"
			Set tDynamicAddressFrom.email			= "teste@tes.com"
			Set tDynamicAddressFrom.document		= "44444444409"
			Set tDynamicAddressFrom.street			= "Rua Pilar do Sul"
			Set tDynamicAddressFrom.number			= 10
			Set tDynamicAddressFrom.complement		= "Casa 1"
			Set tDynamicAddressFrom.neighborhood	= "AAAAA"
			Set tDynamicAddressFrom.city			= "Sao Paulo"
			Set tDynamicAddressFrom.uf				= "SP"
			Set tDynamicAddressFrom.country			= "Sao Paulo"
			Set tDynamicAddressFrom.zipcode			= "06333150"
			
			Set tDynamicAddressTo = ##Class(%DynamicObject).%New()
			
			Set tDynamicAddressTo.name				= "Andreia From"
			Set tDynamicAddressTo.phone				= "5511999999999"
			Set tDynamicAddressTo.email				= "teste@tes.com"
			Set tDynamicAddressTo.document			= "44444444409"
			Set tDynamicAddressTo.street			= "Rua Pilar do Sul"
			Set tDynamicAddressTo.number			= 10
			Set tDynamicAddressTo.complement		= "Casa 1"
			Set tDynamicAddressTo.neighborhood		= "AAAAA"
			Set tDynamicAddressTo.city				= "Sao Paulo"
			Set tDynamicAddressTo.uf				= "SP"
			Set tDynamicAddressTo.country			= "Sao Paulo"
			Set tDynamicAddressTo.zipcode			= "06333150"
			
			Do tArrayItem.%Push(
						{
							"amount":				("1.20"),
							"weight":				(15),
							"width":				(15),
							"height":				(15),
							"length":				(15),
							"insurance_value":		("15"),
							"in_care":				("Andreia To"),
							"address_from":			(tDynamicAddressFrom),
							"address_to":			(tDynamicAddressTo),		
							"observation":			("mocker"),
							"creationDateTime":		("2023-01-01 10:00:00")
						}
			)
			
			Set tArrayObject = ##Class(%DynamicArray).%New()
			
			Set tDynamicService = ##Class(%DynamicObject).%New()
			
			Set tDynamicService.transporter	= "Total Express"
			Set tDynamicService.service		= "Total Express"
			
			Do tArrayObject.%Push(
				{
					"shipmentId":		("123344444"),
					"orderId":			("123444444"),
					"tag":				("TOTAL123455555EXP"),
					"plpId":			(""),
					"service":			(tDynamicService),
					"item":				(tArrayItem)
				}
			)
			
			Set tArrayAnswer = ##Class(%DynamicArray).%New()
			
			Do tArrayAnswer.%Push(
				{
					"status":			(1),
					"mensagem":			("Sucesso"),
					"codigoMensagem":	("Create Tracking"),
					"sessionId":		(..%SessionId)
				}
			)
			
			Set tDynamicResponse.object 	= tArrayObject
			Set tDynamicResponse.answer		= tArrayAnswer
			
			Do pOutput.Write(tDynamicResponse.%ToJSON())
		}
	}
	Catch (tException)
	{
		Set tSC =  $System.Status.GetErrorText(tException.AsStatus())
		
		Set tBodyData = tException.Data
		Set tBodyData = $ZCONVERT(tBodyData,"O","UTF8")
		Set pOutput.Attributes("ResponseCode") = "500 Internal Server Error"
		
		Do pOutput.Write(tBodyData)
	}
		
		
	Set pOutput.Attributes("Content-Type") = "application/json"	
	Quit tSC
}

Method MockerTrace(pInput As %Stream.GlobalCharacter, Output pOutput As %Stream.GlobalCharacter, pTag As %String) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	
	Try
	{
		//Set tArray = ##class(%ArrayOfDataTypes).%New()
		
		Set tParams = pInput.Attributes("RawParams")
		
		Set (tOrderId, tShipmentId) = ""
		
		If (tParams '="")
		{
			For i=1:1:$Length(tParams,"&")
			{
				Set tParam = $Piece(tParams,"&",i)
				//Do tArray.SetAt($Piece(tParam,"=",2),$Piece(tParam,"=",1))
				$$$LOGINFO($Piece(tParam,"=",2)_" "_$Piece(tParam,"=",1))
				
				If ($Piece(tParam,"=",1) = "shipmentId")
				{
					Set tShipmentId = $Piece(tParam,"=",2)
				}
				ElseIf ($Piece(tParam,"=",1) = "orderId")
				{
					Set tOrderId = $Piece(tParam,"=",2)
				}
			}
		}
		
		//Set tSC = ##Class(Ens.Util.JSON).ObjectToJSONStream(tArray,.tEntity)
		
		//$$$LOGINFO(tJSONRequest)
					
		Set tDynamicResponse = ##Class(%DynamicObject).%New()
		
		Set tArrayDetails = ##Class(%DynamicArray).%New()
		
		
		Do tArrayDetails.%Push(
					{
						"tag":						(pTag),
						"currentDescription":		("Tracking Criado"),
						"status":					("Criado"),
						"updateDateTime":			("2023-01-01 10:00:00"),
						"observation":				("mocker")
					}
		)
		
		Do tArrayDetails.%Push(
					{
						"tag":						(pTag),
						"currentDescription":		("Postado"),
						"status":					("Postado"),
						"updateDateTime":			("2023-01-01 14:30:00"),
						"observation":				("mocker")
					}
		)
		
		Do tArrayDetails.%Push(
					{
						"tag":						(pTag),
						"currentDescription":		("Em rota para o CD São Paulo"),
						"status":					("Em Andamento"),
						"updateDateTime":			("2023-01-01 18:40:00"),
						"observation":				("mocker")
					}
		)
		
		Set tArrayObject = ##Class(%DynamicArray).%New()
		
		Do tArrayObject.%Push(
			{
				"shipmentId":		(tShipmentId),
				"orderId":			(tOrderId),
				"tag":				(pTag),
				"plpId":			(""),
				"details":			(tArrayDetails)
			}
		)
		
		Set tArrayAnswer = ##Class(%DynamicArray).%New()
		
		Do tArrayAnswer.%Push(
			{
				"status":			(1),
				"mensagem":			("Sucesso"),
				"codigoMensagem":	("Consult performed successfully"),
				"sessionId":		(..%SessionId)
			}
		)
		
		Set tDynamicResponse.object 	= tArrayObject
		Set tDynamicResponse.answer		= tArrayAnswer
		
		Do pOutput.Write(tDynamicResponse.%ToJSON())
	}
	Catch (tException)
	{
		Set tSC =  $System.Status.GetErrorText(tException.AsStatus())
		
		Set tBodyData = tException.Data
		Set tBodyData = $ZCONVERT(tBodyData,"O","UTF8")
		Set pOutput.Attributes("ResponseCode") = "500 Internal Server Error"
		
		Do pOutput.Write(tBodyData)
	}
			
	Set pOutput.Attributes("Content-Type") = "application/json"	
	Quit tSC
}

}
