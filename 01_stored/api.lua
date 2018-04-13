local m = {}

m.init = function()
   local t = box.schema.space.create('tokens', { if_not_exists=true })

   t:create_index('pk', { if_not_exists=true })
end

m.consume = function(user_id)

    local token = box.space.tokens:get({user_id})

    if token ~= nil then
         local count = token[2]
         if count >= 3 then
             return { ok = false, token  }
         end
         
         box.space.tokens:update({user_id}, {{'+', 2, 1}})

	return { ok = true, token }

    end

    token = box.space.tokens:insert({user_id, 0})

    return { ok = true, token }
end
return m
