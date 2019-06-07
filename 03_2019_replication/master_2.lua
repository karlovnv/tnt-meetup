box.cfg{
    memtx_memory = 1 * 1024 * 1024 * 1024,
    listen = '127.0.0.1:4402',
    read_only = false,
    replication = {
        'replicator:replicator@127.0.0.1:4401',
        'replicator:replicator@127.0.0.1:4402',
    },
	--work_dir = '/root/megafon/replication/master_2',
}

box.once('create_schema', function()
    box.schema.user.create('replicator', { password = 'replicator' })
    box.schema.user.grant('replicator', 'replication')

    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

rawset(_G, 'handler', require('app').handler)

