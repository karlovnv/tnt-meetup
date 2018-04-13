
local box = require('box')
local clock = require('clock')
local expirationd = require('expirationd')
local module = {}

function module.init(config)
    local tokens = box.schema.space.create('documents', {if_not_exists = true})

    -- add validation by schema
    tokens:format({
        {'uuid', 'string'},
        {'subscriber_id', 'unsigned',is_nullable=true},
        {'customer_id', 'unsigned',is_nullable=true},
        {'doc_id', 'string'},
        {'expire', 'unsigned'}
    })

    tokens:create_index('uuid', {parts = {'uuid'}, type='HASH', if_not_exists = true})
    tokens:create_index('subscriber_id', {parts = {'subscriber_id', is_nullable = true}, unique = false, if_not_exists = true})
    tokens:create_index('customer_id', {parts = {'customer_id', is_nullable = true}, unique = false, if_not_exists = true})
    tokens:create_index('doc_id', {parts = {'doc_id'}, unique = false, if_not_exists = true})

    function is_expired(args, tuple)
      return clock.time() >= tuple[5] 
    end

    function delete_tuple(space_id, args, tuple)
      box.space[space_id]:delete{tuple[1]}
    end

    expirationd.start('expire docs', box.space.documents.id, is_expired, {
        process_expired_tuple = delete_tuple,
        args = nil,
        tuples_per_iteration = config.tuples_per_iteration, 
        full_scan_time = config.full_scan_time
    })

end

return module