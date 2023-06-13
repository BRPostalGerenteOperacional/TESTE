## Integração IRIS com BR POSTAL

Este repositório contém o código-fonte e a documentação para a integração do sistema IRIS Community com a BR POSTAL usando Docker. A integração foi desenvolvida com o objetivo de criar e consultar etiquetas para envio de encomendas através da transportadora J&T.

#Requisitos

- [ ] Docker
- [ ] Docker Compose
- [ ] Git

## Como utilizar

- [ ] Clone este repositório:

```
git clone https://gitlab.com/isnew-digital-tech/is-new-digital-tech/brpostal/integracao-iris.git
cd integracao-iris-brpostal
```

Acesse a aplicação em http://localhost:52773/ (ou a porta configurada no arquivo .env).Faça uma cópia do arquivo .env.example e renomeie para .env. Edite as variáveis de ambiente conforme necessário.

- [ ] Construa e inicie o container Docker:

```
docker-compose up -d
```
## Funcionalidades

- [ ] Criação de ordens de etiquetas J&T
- [ ] Consulta de etiquetas geradas J&T
- [ ] Cancelamento da etiqueta J&T
- [ ] Consulta da tracking J&T

## Documentação

A documentação detalhada da API e dos serviços utilizados nesta integração pode ser encontrada na pasta docs/.

## Exemplos de uso

Para criar uma ordem de etiqueta:
```
POST /api/jt/order/addOrder
Content-Type: application/json
Authorization: Generate

{
   "shipmentId":12,
   "weight":"15",
   "insurance_value":"0",
   "amount":"22.67",
   "length":"15",
   "width":"15",
   "height":"15",
   "service":"Standard Express",
   "serviceType":"EZ",
   "address_to":{
      "name":"TEste BR 2",
      "phone":"11999999999",
      "email":"teste@brpostal.com.br",
      "document":"95849074090",
      "street":"Rua Para",
      "number":"18",
      "complement":"",
      "neighborhood":"Conjunto Habitacional Presidente Castelo Branco",
      "city":"Carapicuiba",
      "state":"SP",
      "country":"BR",
      "zipcode":"06326120",
      "note":null,
      "user_id":"202302130616171"
   },
   "address_from":{
      "name":"Teste BRP",
      "phone":"11999999999",
      "email":"teste@brpostal.com.br",
      "document":"14596183007",
      "street":"Rua Para",
      "number":"18",
      "complement":"",
      "neighborhood":"Conjunto Habitacional Presidente Castelo Branco",
      "city":"Carapicuiba",
      "state":"SP",
      "country":"BR",
      "zipcode":"06326120",
      "note":null,
      "user_id":"202302130616171"
   },
   "invoice":{
      "ncm":"84778090",
      "number":"000001172",
      "serialNumber":"1",
      "requestCode":"1",
      "key":"352209427979820001345500100000011721015100019",
      "date":"2022-09-15",
      "value":"4.900"
   }
}
```

Para consultar as etiquetas geradas:
```
GET /api/jt/order/getOrders
Content-Type: application/json
Authorization: Generate

Query: 
    tag: 888030025645455
```

Para cancelamento das etiquetas geradas:
```
DELETE /api/jt/order/cancelOrder
Content-Type: application/json
Authorization: Generate

{
	"cancel": 1,
	"txlogisticId": "TESTE||124",
	"tag": "888030025645455",
	"orderId": "1"
}
```

Para consulta das tracking geradas:
```
DELETE /api/jt/logistics/trace
Content-Type: application/json
Authorization: Generate

{
	"tags": [
		{
			"tag": "888000004713162"
		},
		{
			"tag": "888030025645455"
		}
	]
}
```

## Suporte
Em caso de problemas ou dúvidas, abra uma issue no repositório ou entre em contato com o suporte técnico da BR POSTAL.

## Licença
Este projeto está licenciado sob a Licença MIT.