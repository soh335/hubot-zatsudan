request = require 'request'
expect  = require 'expect.js'
sinon   = require 'sinon'

Helper = require 'hubot-test-helper'
helper = new Helper './../scripts'

describe 'zatsudan', ->

  describe 'zatsudan chara', ->

    room = null

    beforeEach ->
      room = helper.createRoom()

    it 'reset', ->
      room.user.say 'alice', '@hubot zatsudan chara reset'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

    it 'default', ->
      room.user.say 'alice', '@hubot zatsudan chara default'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

    it 'ゼロ', ->
      room.user.say 'alice', '@hubot zatsudan chara ゼロ'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

    it '20', ->
      room.user.say 'alice', '@hubot zatsudan chara 20'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

    it '桜子', ->
      room.user.say 'alice', '@hubot zatsudan chara 桜子'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

    it '30', ->
      room.user.say 'alice', '@hubot zatsudan chara 30'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

    it 'ハヤテ', ->
      room.user.say 'alice', '@hubot zatsudan chara ハヤテ'
      expect(room.messages[1]).to.eql [
        'hubot', '@alice success to change'
      ]

  describe 'match', ->

    it 'ping', ->
      sinon.spy(request, 'post')

      room = helper.createRoom()
      room.robot.respond /ping/i, (msg) ->
        msg.reply 'pong'

      room.user.say 'alice', '@hubot ping'
      expect(room.messages).to.eql [
        ['alice', '@hubot ping']
        ['hubot', '@alice pong']
      ]

      expect(request.post.callCount).to.be(0)
      request.post.restore()


  describe 'non match', ->

    room = null

    before ->
      room = helper.createRoom()

    runSpec = (who, msg, yields, called) ->
      sinon.stub(request, 'post').yields(yields[0], yields[1], yields[2])
      room.user.say who, msg
      expect(request.post.calledWithMatch(called)).to.be.ok()
      request.post.restore()

      sinon.spy(request, 'post')
      room.user.say who, msg
      expect(room.messages[room.messages.length-2]).to.eql [
        'hubot', "@#{who} #{yields[2]["utt"]}"
      ]
      request.post.restore()

    it 'if statusCode is 500, no response from hubot', ->

      sinon.stub(request, 'post').yields(null, { statusCode: 500 }, {})

      room.user.say 'alice', '@hubot hi'
      expect(room.messages).to.eql [
        ['alice', '@hubot hi']
      ]

      request.post.restore()

    it 'if statusCode is 200, say via request response', ->

      runSpec(
        'alice', '@hubot hi',
        [ null, { statusCode: 200 }, { utt: 'hi!', mode: 'dialog', context: 'abcd' } ],
        { body: { utt: 'hi', mode: 'dialog' } }
      )


    it 'request with context if seted', ->

      runSpec(
        'alice', '@hubot how are you ?',
        [ null, { statusCode: 200 }, { utt: 'fine', mode: 'dialog', context: 'abcd' } ],
        { body: { utt: 'how are you ?', mode: 'dialog', context: 'abcd' } }
      )

    it 'change character', ->
      room.user.say 'alice', '@hubot zatsudan chara 20'

    it 'request with t(character) if seted', ->
      runSpec(
        'alice', '@hubot who are you ?',
        [ null, { statusCode: 200 }, { utt: 'I am 桜子', mode: 'dialog', context: 'abcd' } ],
        { body: { utt: 'who are you ?', mode: 'dialog', context: 'abcd', t: 20 } }
      )
