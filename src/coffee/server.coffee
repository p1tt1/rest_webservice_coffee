http = require 'http'
{addUp, digitSum} = require '../dist/calc.functions'

ACCEPT_CONTENT_TYPES = [undefined, '*/*', 'application/json']
REQUEST_CONTENT_TYPES = ['application/json']
HTTP_METHODS = ['POST']

ERR_DICT = 'ERR_HTTP_METHOD': 405

PORT = process.env.PORT || 5000

getStatusCode = (pErrMsg) ->
  return 200 unless pErrMsg?
  if ERR_DICT[pErrMsg]? then ERR_DICT[pErrMsg] else 400

getHead = (pErrMsg) ->
  [getStatusCode(pErrMsg), 'Content-Type': 'application/json']

parseDataAsJSON = (pReq) ->
  new Promise (pResolve, pReject) ->
    lData = []
    pReq
      .on 'data', (pChunk) -> lData.push pChunk
      .on 'end', ->
        try
          pResolve JSON.parse Buffer.concat(lData).toString()
        catch pErr
          pReject new Error 'ERR_PARSE_JSON'

writeErrRes = (pRes, pErr) ->
  pRes.writeHead getHead(pErr)...
  pRes.write JSON.stringify error: pErr
  pRes.end()

server = http.createServer (pReq, pRes) ->
  unless pReq.method in HTTP_METHODS
    return writeErrRes pRes, 'ERR_HTTP_METHOD'
  unless pReq.headers.accept in ACCEPT_CONTENT_TYPES
    return writeErrRes pRes, 'ERR_ACCEPT'
  unless pReq.headers?['content-type'] in REQUEST_CONTENT_TYPES
    return writeErrRes pRes, 'ERR_CONTENT_TYPE'
  unless pReq.headers?['content-length'] > 0
    return writeErrRes pRes, 'ERR_CONTENT_LENGTH'
  parseDataAsJSON pReq
    .then (pData) ->
      pRes.writeHead getHead()...
      pRes.write JSON.stringify result: digitSum addUp pData?.address?.values
      pRes.end()
    .catch (pErr) -> writeErrRes pRes, pErr.message

server.listen PORT, -> console.log "Listening on #{PORT}"
module.exports = server
