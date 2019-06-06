-- setup tarantool as a DB
box.cfg( {
    listen = 3301
})

-- grant
box.once('gr', function()
--  box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

-- create space
local u = box.schema.space.create('user', {
    if_not_exists = true
})

u:format({ 
    { name = "id", type = "unsigned" }, 
    { name = "name", type = "string" }, 
    { name = "age", type = "unsigned" }
})

u:create_index('pk', { if_not_exists = true })
u:create_index('age', {
     parts = {
         {'name', 'string'}, 
         {'age', 'unsigned'}
        }, 
        unique = false, 
        if_not_exists = true})

-- global function is a stored procedure
function test(s)
  return s
end

-- create new user or increment age for an existing one
function create_or_update(id, name, age)
  local t = u:get({id})
  if t ~= nil then
    return u:update({id},{{"+", 3, 1}})
  end
  return u:insert({id, name, age})
end
