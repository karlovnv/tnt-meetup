return {
    box = {
        listen = 4001,
        wal_dir = 'data',
        memtx_dir = 'data'
    },
    app = {
        expiration = 1, -- in mins
        tuples_per_iteration = 10,
        full_scan_time = 60 -- in secs
    }
}
