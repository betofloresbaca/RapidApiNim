
include ./api_macros
import print

# buildMetaSpecFile("deezer.api.json", "deezer.api.meta.json")
# print loadMetaSpec("deezer.api.meta.json")
buildMetaSpecFile("postman.api.json", "postman.api.meta.json")
print loadMetaSpec("postman.api.meta.json")


# api(DeezerRapidApi, "deezer.api.json")

# var deezer = newDeezerRapidApi("debf185ea0msh3836723477176cep1e6970jsnbd5195c21f72")

# print deezer
# print loadApiSpec("alpha_vantaje.api.json")

# proc tableAsQueryParameters(params: Table[string, string]): string =
#   result = ""
#   for key, value in params:
#     if result.len > 0:
#       result.add("&")
#     result.add(key & "=" & value)


# proc getTimeSeriesDaily(api: AlphaVantageApi, symbol: string, datatype: string = "json", outputsize: string = "compact"): JsonNode =
#   var client = newHttpClient()
#   client.headers = newHttpHeaders({ "X-RapidAPI-Host": "alpha-vantage.p.rapidapi.com", "X-RapidAPI-Key": api.api_key })
#   let route = fmt"https://alpha-vantage.p.rapidapi.com/query?function=TIME_SERIES_DAILY&symbol={symbol}&outputsize={outputsize}"
#   let response = client.request(url = route, httpMethod = HttpMethod.HttpGet)
#   return parseJson(response.body)

# echo alpha_vantage.getTimeSeriesDaily(symbol = "MSFT")





### EXPECTED GENERATED CODE


# import httpclient

# type
#   AlphaVantageRapidApi = object
#     key: string

# proc newAlphaVantageRapidApi(key: string): AlphaVantageRapidApi =
#   result = AlphaVantageRapidApi()
#   result.key = key

# proc getTimeSeriesDaily(api: AlphaVantageApi, symbol: string, datatype: string = "json", outputsize: string = "compact"): JsonNode =
#   var client = newHttpClient()
#   client.headers = newHttpHeaders({ "X-RapidAPI-Host": "alpha-vantage.p.rapidapi.com", "X-RapidAPI-Key": api.api_key })
#   let route = fmt"https://alpha-vantage.p.rapidapi.com/query?function=TIME_SERIES_DAILY&symbol={symbol}&outputsize={outputsize}"
#   let response = client.request(url = route, httpMethod = HttpMethod.HttpGet)
#   return parseJson(response.body)

# echo alpha_vantage.getTimeSeriesDaily(symbol = "MSFT")

## USAGE EXAMPLE

# const alpha_vantage = newAlphaVantageRapidApi("debf185ea0msh3836723477176cep1e6970jsnbd5195c21f72")
