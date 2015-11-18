# hoster

```
curl -X GET --compressed -H 'Content-Type: application/json' http://0.0.0.0:8080 | python -mjson.tool
curl -X POST -d "{ \"text\":\"Joel\" }" --compressed -H 'Content-Type: application/json' http://0.0.0.0:8080 | python -mjson.tool
curl -X POST -H 'Content-Type: application/json' http://0.0.0.0:8080/?text=Joel | python -mjson.tool
curl -X GET -H 'Content-Type: application/json' http://0.0.0.0:8080/list | python -mjson.tool
```
