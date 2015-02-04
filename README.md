# hubot-zatsudan

hubot-zatsudan is a port of [ruboty-talk](https://github.com/r7kamura/ruboty-talk).

## Installation

In hubot project repo, run:

```
npm install hubot-zatsudan
```

Then add ```hubot-zatsudan``` to your external-scripts.json

```
["hubot-zatsudan"]
```

## Usage

### APIKEY

Should set ```HUBOT_DOCOMO_APIKEY```. You can get apikey from [docomo developer support site](https://dev.smt.docomo.ne.jp/).

### Change Character

```
Hubot> @hubot zatsudan chara 桜子
Shell: success to change
```

* possible character list ( see https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_docs_id=5 )
    * ゼロ ( default )
    * 桜子
    * ハヤテ
