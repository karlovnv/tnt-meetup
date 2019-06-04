To run an app write in this directory

```
tarantool init.lua
```

To connect to the instance run 
```
tarantoolctl connect "0.0.0.0:3301"
```

To view human readable wal use
```
tarantoolctl cat <file .xlog>
```