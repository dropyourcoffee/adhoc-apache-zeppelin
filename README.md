# adhoc-apache-zeppelin
Adhoc apache-zeppelin for Qraft(Namely, ZepplinQ)


shiro Authentication is enabled by default.
To copy default authentication
```bash
    cp ./zeppelin/conf/shiro.ini.template ./zeppelin/conf/shiro.ini

```

Run example
```bash
docker build -t zeppelinq:0.0.1-beta .
&& docker run
-p 8080:8080
-v __PROJECT_DIR__/zeppelin/conf:/zeppelin/conf
-v __PROJECT_DIR__/zeppelin/notebook:/zeppelin/notebook
--name zeppelinq
zeppelinq:0.0.1-beta 
```

Few initialising scripts must be executed after run.
```bash
docker exec init-hompage
docker exec -d start-notebook

```

