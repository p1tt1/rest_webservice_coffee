
exports.addUp = (pArray) ->
  throw new Error('ERR_ADDUP_PARAM') unless Array.isArray pArray
  pArray
    .filter (pVal) -> Number.isInteger pVal
    .reduce ((pTotal, pInt) -> pTotal + pInt), 0

exports.digitSum = (pNumber) ->
  throw new Error('ERR_DIGITSUM_PARAM') unless Number.isInteger pNumber
  [...Math.abs(pNumber).toString()]
    .map Number
    .reduce ((pTotal, pDigit) -> pTotal + pDigit), 0
