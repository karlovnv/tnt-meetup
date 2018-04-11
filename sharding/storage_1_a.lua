local box = require('box')
vshard = require('vshard')
local data_api = require('data-api')

local cfg = require('vshard-config')

cfg.listen = 33001
cfg.wal_dir = 'storage_1_a'
cfg.memtx_dir = 'storage_1_a'

vshard.storage.cfg(cfg, '8a274925-a26d-47fc-9e1b-af88ce939412')

box.once('init', function()
    box.schema.user.grant('guest', 'read,write,execute', 'universe')
    box.schema.user.grant('storage', 'read,write,execute', 'universe')
    box.schema.user.passwd('storage', 'storage')
end)

data_api.init()

-- declaration of module with stored procedures
-- api.my_api.say_hello2
rawset(_G, 'api', {
    data_api = data_api
})