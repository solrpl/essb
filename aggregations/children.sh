curl -XDELETE 'localhost:9200/images'

curl -XPOST 'localhost:9200/images' -d '{
 "mappings" : {
  "image" : {
   "properties" : {
    "name" : { "type" : "string", "index" : "not_analyzed" },
    "author" : { "type" : "string", "index" : "not_analyzed" }
   }
  },
  "comment" : {
   "_parent" : {
    "type" : "image"
   },
   "properties" : {
    "text" : { "type" : "string" },
    "nick" : { "type" : "string", "index" : "not_analyzed" } 
   }
  }
 }
}'

curl -XPOST 'localhost:9200/images/image/1' -d '{
 "name" : "Image 1",
 "author" : "gr0"
}'

curl -XPOST 'localhost:9200/images/comment/1?parent=1' -d '{
 "text" : "comment 1",
 "nick" : "comm1"
}'

curl -XPOST 'localhost:9200/images/comment/2?parent=1' -d '{
 "text" : "comment 2",
 "nick" : "comm2"
}'

curl -XPOST 'localhost:9200/images/image/2' -d '{
 "name" : "Image 2",
 "author" : "test"
}'

curl -XPOST 'localhost:9200/images/comment/3?parent=2' -d '{
 "text" : "comment 21",
 "nick" : "comm21"
}'

curl -XPOST 'localhost:9200/images/comment/4?parent=2' -d '{
 "text" : "comment 22",
 "nick" : "comm22"
}'

curl -XPOST 'localhost:9200/images/image/3' -d '{
 "name" : "Image 3",
 "author" : "new author"
}'

curl -XPOST 'localhost:9200/images/comment/5?parent=3' -d '{
 "text" : "comment 31",
 "nick" : "comm1"
}'

curl -XPOST 'localhost:9200/images/comment/6?parent=3' -d '{
 "text" : "comment 32",
 "nick" : "comm2"
}'

curl -XPOST 'localhost:9200/images/comment/7?parent=3' -d '{
 "text" : "comment 33",
 "nick" : "comm2"
}'

curl -XPOST 'http://localhost:9200/images/_refresh'

curl -XGET 'localhost:9200/images/_search?pretty' -d '{
 "aggregations" : {
  "images" : {
   "terms" : {
    "field" : "name"
   },
   "aggregations" : {
    "number_of_comments" : {
     "children" : {
      "type" : "comment"
     }
    }
   }
  }
 }
}'