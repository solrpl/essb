curl -XDELETE 'localhost:9200/images'

curl -XPOST 'localhost:9200/images' -d '{
 "mappings" : {
  "image" : {
   "properties" : {
    "name" : { "type" : "string", "index" : "not_analyzed" },
    "author" : { "type" : "string", "index" : "not_analyzed" },
    "comments" : {
     "type" : "nested",
     "properties" : {
      "text" : { "type" : "string" },
      "nick" : { "type" : "string", "index" : "not_analyzed" } 
     }
    }
   }
  }
 }
}'

curl -XPOST 'localhost:9200/images/image/1' -d '{
 "name" : "Image 1",
 "author" : "gr0",
 "comments" : [
  {
   "text" : "comment 1",
   "nick" : "comm1"
  },
  {
   "text" : "comment 2",
   "nick" : "comm2"
  } 
 ]
}'

curl -XPOST 'localhost:9200/images/image/2' -d '{
 "name" : "Image 2",
 "author" : "test",
 "comments" : [
  {
   "text" : "comment 21",
   "nick" : "comm21"
  },
  {
   "text" : "comment 22",
   "nick" : "comm22"
  } 
 ]
}'

curl -XPOST 'localhost:9200/images/image/3' -d '{
 "name" : "Image 3",
 "author" : "new author",
 "comments" : [
  {
   "text" : "comment 31",
   "nick" : "comm1"
  },
  {
   "text" : "comment 32",
   "nick" : "comm2"
  } 
 ]
}'

curl -XPOST 'http://localhost:9200/images/_refresh'

curl -XGET 'localhost:9200/images/_search?pretty' -d '{
 "aggregations" : {
  "comments" : {
   "nested" : {
    "path" : "comments"
   },
   "aggregations" : {
    "commenters" : {
     "terms" : {
      "field" : "comments.nick"
     },
     "aggregations" : {
      "reversed_example" : {
       "reverse_nested" : {}
      }
     }
    }
   }
  }
 }
}'