---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by nikolay.karlov.
--- DateTime: 06/06/2019 11:13
---
api = require ('api')

-- setup tarantool as a DB
box.cfg( {
    listen = 3301
})

-- grant
box.once('gr', function()
--    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

api.init()
