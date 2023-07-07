import macros
import macroutils
import ./spec_parse

template apiTypeDefinition(typeName: untyped): untyped =
  type
    typeName = object
      api_key: string

template apiTypeConstructor(identifier: untyped): untyped =
  proc `new identifier`(api_key: string): `identifier` =
    result = identifier()
    result.api_key = api_key

# proc formatQueryParameters(params: seq[ParameterSpec]): string =
#   result = params
#     .filterIt(it.)
#     .mapIt(fmt"{it[0]}={it[1]}")
#     .join("&")

proc createEndpointMethod(endpoint: EndpointSpec): NimNode =
  result = newStmtList()
  # result.add newProc(
  #   Ident(endpoint.httpMethod & endpoint.name)
  #     FormalParams())

macro api(typeName: untyped, spec_filename: untyped) : untyped =
  result = newStmtList()
  echo spec_filename.strVal
  # Loading spec file
  # let spec = loadApiSpec(spec_filename.strVal)
  ### Building code
  # Imports
  result.add ImportStmt(Ident("httpclient"), Ident("tables"))
  # Type declaration
  result.add getAst(apiTypeDefinition(typeName))
  # Type constructor
  result.add getAst(apiTypeConstructor(typeName))
  # Endpoints
  # for endpoint in spec.endpoints:
  #   result.add createEndpointMethod(endpoint)
  echo result.repr
