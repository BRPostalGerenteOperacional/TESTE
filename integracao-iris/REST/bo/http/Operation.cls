Class REST.bo.http.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SendService(pRequest As REST.bo.http.msg.Request, Output pResponse As REST.bo.http.msg.Response) As %Status
{
	Set tSC = $$$OK
	Set pResponse = ##class(REST.bo.http.msg.Response).%New()
	Set tConteudo=""
	
	Try
	{
		Set tClassProxy = ##class(%Net.HttpRequest).%New()
		
		Set tClassProxy.ContentType = pRequest.sendData.ContentType
		
		For i=1:1:pRequest.sendData.Headers.Count()
		{
			Set tValor = pRequest.sendData.Headers.GetAt(i)
			Do tClassProxy.SetHeader($PIECE(tValor,";",1),$PIECE(tValor,";",2))
		}
		
		For i=1:1:pRequest.sendData.FormEncoded.Count()
		{
			Set tValor = pRequest.sendData.FormEncoded.GetAt(i)

			Do tClassProxy.InsertFormData($PIECE(tValor,";",1),$PIECE(tValor,";",2))
		}

		If (pRequest.sendData.Contents.Size>0)
		{
			Set tDados = ##Class(%Stream.GlobalCharacter).%New()
			
			While ('pRequest.sendData.Contents.AtEnd)
			{			
				Set tLine = pRequest.sendData.Contents.Read()
				Do tDados.Write(tLine)
			}
		
			Do tDados.Rewind()
					
			Set tConteudo(1) = tDados
		}
		
		If (pRequest.sendData.ComplementUrl = "")
		{
			Set ..Adapter.URL = pRequest.sendData.Url
		}
		Else
		{
			Set tComplemento = ""
			For x=1:1:$Length(pRequest.sendData.ComplementoUrl, ";")
			{
				If (x = 1) 
				{
					Set tComplemento = "?"_$Piece(pRequest.sendData.ComplementoUrl, ";", 1)
				} 
				Else 
				{
					Set tComplemento = tComplemento_"&"_$Piece(pRequest.sendData.ComplementoUrl, ";", x)
				}				
			}	
			Set ..Adapter.URL = pRequest.sendData.Url_tComplemento
		}
	
		If (pRequest.sendData.UrlBase '= "")
		{
			Set ..Adapter.URL = pRequest.sendData.UrlBase_..Adapter.URL
		}
		
		If (pRequest.sendData.Port '= "")
		{
			Set ..Adapter.HTTPPort = pRequest.sendData.Port
		}
		
		If (pRequest.sendData.Server '= "")
		{
			Set ..Adapter.HTTPServer = pRequest.sendData.Server
		}
		
		If (pRequest.sendData.SSLCheckServerIdentity '=0)
		{
			Set ..Adapter.SSLCheckServerIdentity 	= pRequest.sendData.SSLCheckServerIdentity
			Set ..Adapter.SSLConfig					= pRequest.sendData.SSL
		}

		#Dim tResp As %Net.HttpResponse
		Set tSC = ..Adapter.SendFormDataArray(.tResp,pRequest.sendData.Type,tClassProxy,,.tConteudo)
		$$$ThrowOnError(tSC)	

		Set tReturnData = ##class(REST.vo.http.returnData).%New()

		Set tReturnData.Contents 	= tResp.Data.%ConstructClone(1)
		Set tReturnData.StatusLine 	= tResp.StatusLine
		Set tReturnData.StatusCode	= tResp.StatusCode
		Set tReturnData.Status		= tSC
		Set tReturnData.SessionId	= ..%SessionId	
		
	}
	Catch (tException)
	{
		Set tReturnData = ##class(REST.vo.http.returnData).%New()

		If ('$System.Status.IsError(tSC))
		{
			Set tReturnData.StatusMessage = $ZE
			Set tSC = tException.AsStatus()
		}
		
		Set tReturnData.StatusCode 	= 500
		Set tReturnData.StatusLine 	= "500 Internal Server Error"
		Set tReturnData.Status			= tSC
		
	}

	Set pResponse.returnData = tReturnData

	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="REST.bo.http.msg.Request"> 
		<Method>SendService</Method>
	</MapItem>	
</MapItems>
}

}
