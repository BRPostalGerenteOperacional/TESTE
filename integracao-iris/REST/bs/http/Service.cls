Class REST.bs.http.Service Extends EnsLib.REST.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/token/generate" 			Method="GET"		Call="TokenGenerate" />
	<Route Url="/token/validate"			Method="POST"		Call="TokenValidate" />
</Routes>
}

Method TokenGenerate(pInput As %Stream.GlobalCharacter, Output pOutput As %Stream.GlobalCharacter) As %Status [ WebMethod ]
{
	Set tSC =$$$OK
	#Dim tException As %Exception.SystemException
	
		
	Set pOutput.Attributes("Content-Type") = "application/json"	
	Quit tSC
}

}
