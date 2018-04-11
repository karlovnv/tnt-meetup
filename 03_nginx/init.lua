local api = require ('api')

box.cfg({ listen = 3301})

box.once('init', function()
    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

api.init()

function simple(word)
    if word == nil then
        print('word is nil')
    else
        print('Hello, '..word)
    end
    return  word
end

function consume(user_id)
   return api.consume(user_id)
end

function handler(req, data, ...)
   return {req = req, data = data, args = {...}  }
end
