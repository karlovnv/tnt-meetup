box.cfg{
    memtx_memory = 1 * 1024 * 1024 * 1024,
    listen = '127.0.0.1:4401',
    read_only = false,
    replication = {
        'replicator:replicator@127.0.0.1:4401',
        'replicator:replicator@127.0.0.1:4402',
    },
--	work_dir = '/root/megafon/replication/master_1',
}

box.once('create_schema', function()
    box.schema.user.create('replicator', { password = 'replicator' })
    box.schema.user.grant('replicator', 'replication')

    box.schema.space.create('users', { if_not_exists = true })
	box.space.users:format({
		{ name = 'uuid', type = 'string' },
		{ name = 'name', type = 'string' },
		{ name = 'email', type = 'string' },
		{ name = 'created_at', type = 'integer' },
	})
    box.space.users:create_index('pk', { parts = { 'uuid' }, type = 'hash', if_not_exists = true })

    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

rawset(_G, 'handler', require('app').handler)

