
chai = require 'chai'
{addUp, digitSum} = require '../dist/calc.functions'
expect = chai.expect

describe 'addUp tests', ->
  describe 'test invalid parameters', ->
    [
      undefined
      null
      0
      'invalid'
      value: 1
      '[]'
      '[0]'
      ].forEach (pPara) ->
        it "should throw an exception if called with #{JSON.stringify pPara}", ->
          expect(-> addUp pPara).to.throw(Error).with.property 'message', 'ERR_ADDUP_PARAM'

  describe 'test valid parameters', ->
    [
     {para: [], returnVal: 0}
     {para: [0], returnVal: 0}
     {para: [1,2,3], returnVal: 6}
     {para: [-1], returnVal: -1}
     {para: [-1,-2,3], returnVal: 0}
     {para: ['1'], returnVal: 0}
     {para: ['-1'], returnVal: 0}
     {para: ['1', 1], returnVal: 1}
     {para: ['-1', 1], returnVal: 1}
     {para: [1.5], returnVal: 0}
     {para: [-1.5], returnVal: 0}
     {para: [1.5, 1], returnVal: 1}
     {para: [-1.5, 1], returnVal: 1}
     {para: [1.0], returnVal: 1}
     {para: [-1.0], returnVal: -1}
     {para: [100,-200.1,300,-40000,50,-60000,70,-800,0.001], returnVal: -100280}
    ].forEach (pTestCase) ->
      it "should return #{pTestCase.returnVal} if called with #{JSON.stringify pTestCase.para}", ->
        expect(addUp pTestCase.para).to.equal pTestCase.returnVal

describe 'digitSum tests', ->
  describe 'test invalid parameters', ->
    [
      undefined
      null
      'invalid'
      '0'
      1.5
      [1]
      { value: 1 }
      ].forEach (pPara) ->
        it "should throw an exception if called with #{JSON.stringify pPara}", ->
          expect(-> digitSum pPara).to.throw(Error).with.property 'message', 'ERR_DIGITSUM_PARAM'

  describe 'test valid parameters', ->
    [
     {para: 0, returnVal: 0}
     {para: 1, returnVal: 1}
     {para: -0, returnVal: 0}
     {para: -1, returnVal: 1}
     {para: 123, returnVal: 6}
     {para: 123456789, returnVal: 45}
     {para: 2.0, returnVal: 2}
    ].forEach (pTestCase) ->
      it "should return #{pTestCase.returnVal} if called with #{JSON.stringify pTestCase.para}", ->
        expect(digitSum pTestCase.para).to.equal pTestCase.returnVal
