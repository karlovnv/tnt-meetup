# Instructions 
To run an app write in this directory

```
tarantool init.lua
```

To connect to the instance run 
```
tarantoolctl connect "0.0.0.0:3301"
>> create_or_update(1, "vasya", 23)
>> test('hello, world')
```

To view human readable wal use
```
tarantoolctl cat <file .xlog>
```

## Краткое описание лекции 
### Полезные ссылки 
```
Краткий экскурс в синтаксис Lua:
http://tylerneylon.com/a/learn-lua/

Getting started:
https://www.tarantool.io/ru/doc/1.10/book/getting_started/using_binary/
```

### Сервер приложений 
Если запустить тарантул, то открывается консоль с интерпретатором языка lua

```
tarantool
>> a = 1+2
>> a
>> function hello() 
    print('hello')
   end
>> hello()
>> b = {1,2,3,4,"123", {s = 1, b = 3}}
>> b
```

Если вызвать box.cfg, то сервер приложений становится базой данных, 
принимающей подключения на порту 3301

```
>> box.cfg({listen = 3301})
```
Далее мы можем создавать спейсы, индексы и управлять данными

