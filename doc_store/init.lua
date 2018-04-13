local schema = require('schema')
local config = require('config')
local api = require('api')

os.execute(string.format('mkdir -p %s', config.box.wal_dir))
os.execute(string.format('mkdir -p %s', config.box.memtx_dir))

box.cfg(config.box)

box.once('users', function()
    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

schema.init(config.app)

local routes = {
        {
            method = "POST",
            uri = '/api/001/create/doc',
            handler = api.save_document
        },
        {
            method = "POST",
            uri = '/api/001/create/subscriber',
            handler = api.save_document,
        },
        {
            method = "POST",
            uri = '/api/001/create/customer',
            handler = api.save_document
        },
        {
            method = "GET",
            uri = '/api/001/get/customer',
            handler = api.save_document
        }
    }

function http_handler(req, data)
    for _, route in ipairs(routes) do
        if string.startswith(req.uri, route.uri) then
            
            local ok, result = xpcall(route.handler, debug.traceback, req.args, data)
            if not ok then
                return 500, { status = "FAIL", message = result }
            end

            return 200, { status = "OK", result = result }
        end
    end

    return 404, { status = "FAIL", message = "route not found", meta = req}
end