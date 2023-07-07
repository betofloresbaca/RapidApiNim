import json
import sequtils
import httpclient
import strformat
import anycase
import strutils
import re
import options

type
  EndpointResponseTypeEnum* = enum
    EndpointResponseTypeText = "TEXT"
    EndpointResponseTypeJson = "JSON"
  EndpointMethodEnum* = enum
    EndpointMethodGet = "GET"
    EndpointMethodPost = "POST"
    EndpointMethodPut = "PUT"
    EndpointMethodPatch = "PATCH"
    EndpointMethodDelete = "DELETE"
  ParameterTypeEnum* = enum
    ParameterTypeRouteParameter = "ROUTE"
    ParameterTypeHeaderParameter = "HEADER"
  ParameterValueTypeEnum* = enum
    ParameterValueTypeString = "VALUE"
  ParameterConditionEnum* = enum
    ParameterConditionOptional = "OPTIONAL"
    ParameterConditionRequired = "REQUIRED"
  ParameterStatusEnum* = enum
    ParameterStatusActive = "ACTIVE"
  ApiSpecMeta* = object
    hostUrl: string
  EndpointSpecMeta* = object
    procName: string
  ParameterSpecMeta* = object
    other: string
  ApiSpec* = object
    meta: ApiSpecMeta
    host: string
    endpoints: seq[EndpointSpec]
  EndpointSpec* = object
    meta: EndpointSpecMeta
    httpMethod: EndpointMethodEnum
    name: string
    route: string
    description: string
    responseType: EndpointResponseTypeEnum
    parameters: seq[ParameterSpec]
  ParameterSpec* = object
    meta: ParameterSpecMeta
    name: string
    isQueryString: bool
    parameterValueType: ParameterValueTypeEnum
    condition: ParameterConditionEnum
    status: ParameterStatusEnum
    parameterType: ParameterTypeEnum
    value: Option[string]

proc fromJson(T: typedesc[ParameterSpec], json_node: JsonNode): ParameterSpec =
  result.name = json_node["name"].str
  result.isQueryString = json_node["querystring"].getBool
  case json_node["paramType"].str:
    of "STRING":
      result.parameterValueType = ParameterValueTypeString
  case json_node["condition"].str:
    of "REQUIRED":
      result.condition = ParameterConditionRequired
    of "OPTIONAL":
      result.condition = ParameterConditionOptional
  case json_node["status"].str:
    of "ACTIVE":
      result.status = ParameterStatusActive
  case json_node["type"].str:
    of "routeparameter":
      result.parameterType = ParameterTypeRouteParameter
    of "headerparameter":
      result.parameterType = ParameterTypeHeaderParameter
      
  if json_node.hasKey("value"):
    result.value = some(json_node["value"].str)
  else:
    result.value = none(string)

proc fromJson(T: typedesc[EndpointSpec], json_node: JsonNode): EndpointSpec =
  case json_node["method"].str:
    of "GET":
      result.httpMethod = EndpointMethodGet
    of "POST":
      result.httpMethod = EndpointMethodPost
    of "PUT":
      result.httpMethod = EndpointMethodPut
    of "PATCH":
      result.httpMethod = EndpointMethodPatch
    of "DELETE":
      result.httpMethod = EndpointMethodDelete
  result.name = json_node["name"].str
  result.route = json_node["route"].str
  result.description = json_node["description"].str
  case json_node["responsePayloads"][0]["format"].str:
    of "Text":
      result.responseType = EndpointResponseTypeText
    of "JSON":
      result.responseType = EndpointResponseTypeJson
  if json_node["params"].kind == JObject:
    for parameter_json in json_node["params"]["parameters"]:
      result.parameters.add fromJson(ParameterSpec, parameter_json)

proc fromJson(T: typedesc[ApiSpec], json_node: JsonNode): ApiSpec =
  result.host = json_node["data"]["apiVersion"]["publicdns"].filterIt(it["current"].getBool)[0]["address"].str
  for endpoint_json in json_node["data"]["apiVersion"]["endpoints"]:
    result.endpoints.add fromJson(EndpointSpec, endpoint_json)

proc loadApiSpec(spec_filename: string): ApiSpec =
  let json_node = parseJson(readFile(spec_filename))
  result = fromJson(ApiSpec, json_node)

proc buildEndpointSpecMeta(endpoint_spec: var EndpointSpec) =
  let name = ($endpoint_spec.httpMethod).toLower & replace(endpoint_spec.name, re"[\W_]+", "")
  endpoint_spec.meta.procName = camel(name)

proc buildApiSpecMeta(api_spec: var ApiSpec) =
  api_spec.meta.hostUrl = fmt"https://{api_spec.host}"
  for i in 0..<api_spec.endpoints.len:
    buildEndpointSpecMeta(api_spec.endpoints[i])

proc buildMetaSpecFile*(in_filename: string, out_filename: string) =
  var spec = loadApiSpec(in_filename)
  buildApiSpecMeta(spec)
  writeFile(out_filename, pretty(%spec))

proc loadMetaSpec*(filename: string): ApiSpec =
  result = parseJson(readFile(filename)).to(ApiSpec)

