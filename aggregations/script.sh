curl -XDELETE 'localhost:9200/images'

curl -XPOST 'localhost:9200/images' -d '{
 "mappings" : {
  "image" : {
   "properties" : {
    "name" : { "type" : "string", "index" : "not_analyzed" },
    "author" : { "type" : "string", "index" : "not_analyzed" },
    "shares" : { "type" : "integer" }
   }
  }
 }
}'

curl -XPOST 'localhost:9200/images/image/1' -d '{
 "name" : "Image 1",
 "author" : "gr0",
 "shares" : 10
}'

curl -XPOST 'localhost:9200/images/image/2' -d '{
 "name" : "Image 2",
 "author" : "test",
 "shares" : 11
}'

curl -XPOST 'localhost:9200/images/image/3' -d '{
 "name" : "Image 3",
 "author" : "new author",
 "shares" : 12
}'

curl -XPOST 'http://localhost:9200/images/_refresh'

curl -XGET 'localhost:9200/images/_search?pretty' -d '{
 "aggregations" : {
  "shares" : {
   "scripted_metric" : {
    "init_script" : "_agg[\"number_of_shares\"] = 0",
    "map_script" : "_agg.number_of_shares += doc.shares.value",
    "combine_script" : "return _agg.number_of_shares",
    "reduce_script" : "sum = 0; for (number in _aggs) { sum += number }; return sum"
   }
  }
 }
}'