local uuid = require('uuid')
local clock = require('clock')
local json = require('json')
local M = {}

local config = require('config')

function M.save_document(params)
    local space = box.space.documents
    local doc_id = params.doc_id
    local result = {}

    if doc_id == nil or doc_id == '' then
        error('Invalid data: doc_id is required')
    end

    local customer_id = tonumber(params.customer_id)
    local subscriber_id = tonumber(params.subscriber_id)

    if customer_id == nil and subscriber_id == nil then
        error('At least one of customer_id or subscriber_id should be specified')
    end

    local expire_at = clock.time() + config.app.expiration * 60
    expire_at = expire_at - expire_at % 1

    -- check if exists 
    local documents = space.index[3]:select({ doc_id })

    -- update existing anbd remove duplicates
    if #documents > 0 then
        -- update first document
        -- remove duplicates
        for i, doc in ipairs(documents) do
            local operation = {
                {'=', 2, subscriber_id or box.NULL}, -- properly handle nil
                {'=', 3, customer_id or box.NULL}, -- properly handle nil
                {'=', 5, expire_at }
            }
            
            --print(json.encode(operation))

            if i == #documents then 
                result = space:update({doc[1]}, operation)
            else  
                -- remove duplicate  
                space:remove({doc[1]})
            end
        end
    else
        result = box.space.documents:insert({
            uuid.str(),
            subscriber_id, 
            customer_id,  
            doc_id, 
            expire_at
        })
    end

    return { item = result, params = params }
end

function M.get_doc_by_subscriber()

end

function M.get_doc_by_customer()

end

function M.get_doc_by_id()

end

return M