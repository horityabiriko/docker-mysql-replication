### 初回構築
```
docker-compose build
docker-compose up master
docker exec -i blog-db-master mysql -r db_blog < docker/db/init/001_schema.sql
docker exec -i blog-db-master mysql -r db_blog < docker/db/init/002_sample.sql
docker-compose up slave
docker-compose stop
docker-compose up -d
```

### 次回以降
```
docker-compose up -d
```