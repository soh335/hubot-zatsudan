# Commands
#   hubot zatsudan chara <chara> - change character. <chara> is ゼロ, 桜子 and ハヤテ.

request = require 'request'

module.exports = (robot) ->

  # taken from Robot.respond
  # https://github.com/github/hubot/blob/master/src/robot.coffee#L88
  if robot.alias
    r = new RegExp(
      "^\\s*[@]?(?:#{robot.alias}[:,]?|#{robot.name}[:,]?)\\s*(.+)",
      "i"
    )
  else
    r = new RegExp(
      "^\\s*[@]?#{robot.name}[:,]?\\s*(.*)",
      "i"
    )

  context = undefined
  mode    = 'dialog'
  t       = undefined

  robot.respond /zatsudan chara (.*)/i, (msg) ->
    chara = msg.match[1]

    # https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_docs_id=5
    switch chara
      when "reset", "default", "ゼロ"
        t = undefined
        msg.reply "success to change"
      when "20", "桜子"
        t = 20
        msg.reply "success to change"
      when "30", "ハヤテ"
        t = 30
        msg.reply "success to change"
      else
        msg.reply "no match chara: #{chara}"

  robot.catchAll (msg) ->

    matches = msg.message.text.match(r)

    if ! (matches? and matches.length > 1)
      return

    body =
      utt: matches[1]
      mode: mode

    if context?
      body["context"] = context

    if t?
      body["t"] = t

    robot.logger.debug(body)

    request.post({
      url: "https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue"
      qs:
        APIKEY: process.env.HUBOT_DOCOMO_APIKEY
      json: true
      body: body
    }, (err, res, body) ->

      if err
        robot.logger.info(err)
        return

      robot.logger.debug(body)

      if res.statusCode != 200
        robot.logger.info("status code is #{res.statusCode}", body)
        return

      context = body["context"]
      mode    = body["mode"]

      msg.reply body["utt"]
    )
