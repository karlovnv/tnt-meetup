local uuid = require('uuid')
local clock = require('clock')

local M = {}

local function read(id)
	local user = box.space.users:get({ id })
	if user == nil then
		return nil
	end

	return user:tomap({ names_only = true })
end

local function create(name, email)
	local id = uuid.str()

	local user = box.space.users:insert({ id, name, email, math.floor(clock.time()) })

	return user:tomap({ names_only = true })
end

local function update(id, name, email)
	if box.space.users:get({ id }) == nil then
		return nil
	end

	local user = box.space.users:update(id, {
		{ '=', 2, name },
		{ '=', 3, email },
	})

	return user:tomap({ names_only = true })
end

local function delete(id)
	local user = box.space.users:delete({ id })
	if user == nil then
		return nil
	end

	return user:tomap({ names_only = true })
end

function M.handler(req)
	local result
	if req.method == 'GET' then
		result = read(req.args.uuid)
	elseif req.method == 'PUT' then
		result = create(req.args.name, req.args.email)
	elseif req.method == 'POST' then
		result = update(req.args.uuid, req.args.name, req.args.email)
	elseif req.method == 'DELETE' then
		result = delete(req.args.uuid)
	end

	if result == nil then
		return 'unknown uuid'
	end

	return result
end

return M

