
fs = require('fs')
chai = require 'chai'
chaiHttp = require 'chai-http'
server = require '../dist/server.js'
expect = chai.expect

chai.use(chaiHttp);

JSON_EXAMPLE = '{"address":{"colorKeys":["A","G","Z"],"values":[74,117,115,116,79,110]},"meta":{"digits":33,"processingPattern":"d{5}+[a-z&$§]"}}'
JSON_EXAMPLE_RESULT = '{"result":8}'

describe 'test invalid http methods', ->
  ['get', 'put', 'delete', 'patch', 'options'].forEach (methodId) ->
    it "it should get the status code 405, if the method #{methodId} is used", (done) ->
      (chai.request server)[methodId] '/'
        .set 'Content-Type', 'application/json'
        .send JSON_EXAMPLE
        .end (err, res) ->
          expect(res).to.have.status 405
          expect(res).to.be.json
          expect(res.body).to.deep.equal error: 'ERR_HTTP_METHOD'
          done()
      return

describe 'test valid http methods', ->
  it 'it should get the status code 200, if the method post is used', (done) ->
    chai.request server
      .post '/'
      .set 'Content-Type', 'application/json'
      .send JSON_EXAMPLE
      .end (err, res) ->
        expect(res).to.have.status 200
        expect(res).to.be.json
        expect(res.body).to.deep.equal JSON.parse JSON_EXAMPLE_RESULT
        done()
    return

describe 'each url should be a callable url', ->
  [
    '/'
    '/v/e/r/y/l/o/n/g/u/r/l'
    '/with/query?value=1'
    '/\\"/'
    '/  /'
    '/´'
  ].forEach (url) ->
    it "#{url} should be a callable url", (done) ->
      chai.request server
        .post url
        .set 'Content-Type', 'application/json'
        .send JSON_EXAMPLE
        .end (err, res) ->
          expect(res).to.have.status 200
          expect(res).to.be.json
          expect(res.body).to.deep.equal JSON.parse JSON_EXAMPLE_RESULT
          done()
      return

describe 'test accept content types', ->
  it "undefined should be a valid accept content type", (done) ->
      chai.request server
        .post '/'
        .set 'Content-Type', 'application/json'
        .send JSON_EXAMPLE
        .end (err, res) ->
          expect(res).to.have.status 200
          expect(res).to.be.json
          expect(res.body).to.deep.equal JSON.parse JSON_EXAMPLE_RESULT
          done()
      return

  ['*/*', 'application/json'].forEach (contentType) ->
    it "#{contentType} should be a valid accepted content type", (done) ->
      chai.request server
        .post '/'
        .set('Accept', contentType)
        .set 'Content-Type', 'application/json'
        .send JSON_EXAMPLE
        .end (err, res) ->
          expect(res).to.have.status 200
          expect(res).to.be.json
          expect(res.body).to.deep.equal JSON.parse JSON_EXAMPLE_RESULT
          done()
      return

describe 'test invalid accept content types', ->
  [
    'text/html'
    'text/plain'
    'text/xml'
    'image/jpeg'
    'image/x-icon'
    'video/mp4'
  ].forEach (contentType) ->
    it "#{contentType} should be an invalid accept content type", (done) ->
      chai.request server
        .post '/'
        .set('Accept', contentType)
        .set 'Content-Type', 'application/json'
        .send JSON_EXAMPLE
        .end (err, res) ->
          expect(res).to.have.status 400
          expect(res).to.be.json
          expect(res.body).to.deep.equal error: 'ERR_ACCEPT'
          done()
      return

describe 'test valid request content types', ->
  [
    'application/json'
  ].forEach (contentType) ->
    it "#{contentType} should be a valid request content type", (done) ->
      chai.request server
        .post '/'
        .set('Content-Type', contentType)
        .send JSON_EXAMPLE
        .end (err, res) ->
          expect(res).to.have.status 200
          expect(res).to.be.json
          expect(res.body).to.deep.equal JSON.parse JSON_EXAMPLE_RESULT
          done()
      return

describe 'test invalid request content types', ->
  it "undefined should be an invalid request content type", (done) ->
        chai.request server
          .post '/'
          .send JSON_EXAMPLE
          .end (err, res) ->
            expect(res).to.have.status 400
            expect(res).to.be.json
            expect(res.body).to.deep.equal error: 'ERR_CONTENT_TYPE'
            done()
        return

  [
    'text/html'
    'text/plain'
    'text/xml'
    'image/jpeg'
    'image/x-icon'
    'video/mp4'
  ].forEach (contentType) ->
    it "#{contentType} should be an invalid request content type", (done) ->
      chai.request server
        .post '/'
        .set('Content-Type', contentType)
        .end (err, res) ->
            expect(res).to.have.status 400
            expect(res).to.be.json
            expect(res.body).to.deep.equal error: 'ERR_CONTENT_TYPE'
            done()
      return

describe 'test invalid request body', ->
  it "the request body should not be empty", (done) ->
        chai.request server
          .post '/'
          .set 'Content-Type', 'application/json'
          .end (err, res) ->
            expect(res).to.have.status 400
            expect(res).to.be.json
            expect(res.body).to.deep.equal error: 'ERR_CONTENT_LENGTH'
            done()
        return

  [
    'invalid'
    '{ invalid: '
    '<?xml version="1.0" encoding="UTF-8"?>
    <invalid number="true">1</invalid>'
    '{invalid:1}'
    '{"invalid"=1}'
  ].forEach (body) ->
    it "#{body} should be an invalid request body", (done) ->
      chai.request server
        .post '/'
        .set 'Content-Type', 'application/json'
        .send body
        .end (err, res) ->
            expect(res).to.have.status 400
            expect(res).to.be.json
            expect(res.body).to.deep.equal error: 'ERR_PARSE_JSON'
            done()
      return

describe 'test invalid json schemas', ->
  [
    '{"invalid": 1}'
    '{"address": 1}'
    '{"address": {}}'
    '{"address": {"invalid":1}}'
    '{"address": {"values":1}}'
    '{"address": {"values":{}}}'
  ].forEach (body) ->
    it "#{body} should has an invalid json schema", (done) ->
      chai.request server
        .post '/'
        .set 'Content-Type', 'application/json'
        .send body
        .end (err, res) ->
            expect(res).to.have.status 400
            expect(res).to.be.json
            expect(res.body).to.deep.equal error: 'ERR_ADDUP_PARAM'
            done()
      return

describe 'test valid json schemas', ->
  [
    {input: '{"address": {"values":[]}}', output: result: 0}
    {input: '{"address": {"values":[1]}}', output: result: 1}
    {input: '{"address": {"values":[{}]}}', output: result: 0}
    {input: '{"address": {"values":[{"valid":{}}]}}', output: result: 0}
    {input: '{"address": {"values":["valid"]}}', output: result: 0}
    {input: '{"address": {"values":["valid",1]}}', output: result: 1}
    {input: '{"address": {"values":[],"valid":1}}', output: result: 0}
    {input: '{"address": {"values":[]},"valid":1}', output: result: 0}
  ].forEach (pTestCase) ->
    it "#{pTestCase.input} should has an valid json schema", (done) ->
      chai.request server
        .post '/'
        .set 'Content-Type', 'application/json'
        .send pTestCase.input
        .end (err, res) ->
            expect(res).to.have.status 200
            expect(res).to.be.json
            expect(res.body).to.deep.equal pTestCase.output
            done()
      return
