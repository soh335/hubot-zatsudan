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

  robot.catchAll (msg) ->

    matches = msg.message.text.match(r)

    if ! (matches? and matches.length > 1)
      return

    body =
      utt: matches[1]
      mode: mode

    if context?
      body["context"] = context

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
