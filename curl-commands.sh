# ------------------------------------------ # CONFIG ADMIN  ----------------------------------
# Config Example ------------------------------------------ CURL CALLS
# API Manager Service setup
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=api-manager-service' \
  --data 'url=http://localhost:8001/'
# Response
# HTTP/1.1 201 Created
#Date: Fri, 11 Sep 2020 19:37:01 GMT
#Content-Type: application/json; charset=utf-8
#Connection: keep-alive
#Access-Control-Allow-Origin: *
#Server: kong/2.1.1
#Content-Length: 365
#X-Kong-Admin-Latency: 57
#
#{"host":"localhost","id":"ad6d3add-d1c5-477b-8533-a70d1ae7bdcd","protocol":"http","read_timeout":60000,"tls_verify_depth":null,"port":8001,"updated_at":1599853021,"ca_certificates":null,"created_at":1599853021,"connect_timeout":60000,"write_timeout":60000,"name":"api-manager-service","retries":5,"path":"\/","tls_verify":null,"client_certificate":null,"tags":null}%

# Api Host Route # not run on the AWS box.
curl -i -X POST \
  --url http://localhost:8001/services/api-manager-service/routes \
  --data 'hosts[]=api-manager.org'
# Response:
# HTTP/1.1 201 Created
#Date: Fri, 11 Sep 2020 19:41:50 GMT
#Content-Type: application/json; charset=utf-8
#Connection: keep-alive
#Access-Control-Allow-Origin: *
#Server: kong/2.1.1
#Content-Length: 433
#X-Kong-Admin-Latency: 25
#
#{"id":"612ee3cb-96a5-40cc-8b72-036a5e00df63","path_handling":"v0","paths":null,"destinations":null,"headers":null,"protocols":["http","https"],"created_at":1599853310,"snis":null,"service":{"id":"ad6d3add-d1c5-477b-8533-a70d1ae7bdcd"},"name":null,"strip_path":true,"preserve_host":false,"regex_priority":0,"updated_at":1599853310,"sources":null,"methods":null,"https_redirect_status_code":426,"hosts":["api-manager.org"],"tags":null}%

# ------------------------------------------ # CONFIG ADMIN  ----------------------------------
# First setup - using the path option, but the paths get long and confusing.
# Securing the Admin API
#curl -X POST http://localhost:8001/services \
#  --data name=admin-api \
#  --data url=http://localhost:8001/
# Response
# {"host":"localhost","id":"09e6a9cc-d869-465c-9e35-926ba00b2c20","protocol":"http","read_timeout":60000,"tls_verify_depth":null,"port":8001,"updated_at":1599599038,"ca_certificates":null,"created_at":1599599038,"connect_timeout":60000,"write_timeout":60000,"name":"admin-api","retries":5,"path":"\/","tls_verify":null,"client_certificate":null,"tags":null}

curl -i -X POST \
  --url http://localhost:8001/services/api-manager-service/routes \
  --data 'paths[]=/api-manager-service/'
#RESPONSE AWS
# {
#   "id":"57e691bc-f7b1-4527-b872-8d343d28cc31",
#   "path_handling":"v0",
#   "paths":["\/api-manager-service\/"],
#   "destinations":null,
#   "headers":null,
#   "protocols":["http","https"],
#   "created_at":1600470181,
#   "snis":null,
#   "service":{"id":"1fec427f-13af-41cf-86c7-414ce2594a86"},
#   "name":null,
#   "strip_path":true,
#   "preserve_host":false,
#   "regex_priority":0,
#   "updated_at":1600470181,
#   "sources":null,
#   "methods":null,
#   "https_redirect_status_code":426,
#   "hosts":null,
#   "tags":null
# }

curl -i -X GET \
  --url http://localhost:8001/services/api-manager-service/routes

curl -i -X POST http://localhost:8001/services/admin-api/routes \
  -H "Content-Type: application/json" \
  -d '{"name": "admin-route", "paths": [ "/api-manager-service" ]}'
# Response
# {"id":"d774d05d-afde-42d8-b131-d7a36eb16031",
# "path_handling":"v0",
# "paths":["\/admin-api"],
# "destinations":null,
# "headers":null,
# "protocols":["http","https"],
# "created_at":1599842752,
# "snis":null,
# "service":{"id":"09e6a9cc-d869-465c-9e35-926ba00b2c20"},
# "name":"admin-route",
# "strip_path":true,
# "preserve_host":false,
# "regex_priority":0,
# "updated_at":1599842752,
# "sources":null,
# "methods":null,
# "https_redirect_status_code":426,
# "hosts":null,
# "tags":null
# }

# enabling Key-auth Plugin. for Api-admin-service
curl -i -X POST \
  --url http://localhost:8001/services/api-manager-service/plugins/ \
  --data 'name=key-auth'
# Response
# {"created_at":1599860409,"consumer":null,"id":"0f406fc0-d55d-4f0e-a22b-200c11d08801","service":{"id":"09e6a9cc-d869-465c-9e35-926ba00b2c20"},"enabled":true,"route":null,"tags":null,"config":{"key_in_body":false,"key_names":["apikey"],"anonymous":null,"hide_credentials":false,"run_on_preflight":true},"protocols":["grpc","grpcs","http","https"],"name":"key-auth"}%
# AWS # {"created_at":1600465843,"consumer":null,"id":"06dbadf9-bfc5-489f-a38a-92eff3f2b902","service":{"id":"1fec427f-13af-41cf-86c7-414ce2594a86"},"enabled":true,"route":null,"tags":null,"config":{"key_in_body":false,"key_names":["apikey"],"anonymous":null,"hide_credentials":false,"run_on_preflight":true},"protocols":["grpc","grpcs","http","https"],"name":"key-auth"}


# make consumer for Admin service:
# ------------------------------------------ # Consumer   ----------------------------------

## Create a Consumer....
curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=dwclogic"
# Response
# {
#     "custom_id":null,
#     "created_at":1599236454,
#     "id":"34e7edd3-413b-4404-9c6d-3ccb517fa8c4",
#     "tags":null,
#     "username":"dwclogic"
# }
# AWS # {"custom_id":null,"created_at":1600465986,"id":"add0d442-f3e6-42e5-ae64-a88680ec7fce","tags":null,"username":"dwclogic"}

#Add a key
curl -i -X POST \
  --url http://localhost:8001/consumers/dwclogic/key-auth/ \
  --data 'key=06104FC3-0A62-4759-8606-8F3011441022' # real key is in my persomal notes file until we can get a better system setup::
# ------------------------------------------ # CONFIG ADMIN  ----------------------------------




# Direct to 8001 ! -------------------------------------
# EXAMPLE ------------------------------------------ SERVICE
# Add a service Using the Admin Api
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=http://mockbin.org'
# response:
# {
#   "host":"mockbin.org",
#   "id":"33bd5149-6256-41b7-acb4-ad32ef08c0fb",
#   "protocol":"http",
#   "read_timeout":60000,
#   "tls_verify_depth":null,
#   "port":80,
#   "updated_at":1599230412,
#   "ca_certificates":null,
#   "created_at":1599230412,
#   "connect_timeout":60000,
#   "write_timeout":60000,
#   "name":"example-service",
#   "retries":5,
#   "path":null,
#   "tls_verify":null,
#   "client_certificate":null,
#   "tags":null
# }

# Add a Route for the Service
curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'hosts[]=example.com'
# Response
# {
#     "id":"3eed97fd-15b1-458b-85c4-94850717a552",
#     "path_handling":"v0",
#     "paths":null,
#     "destinations":null,
#     "headers":null,
#     "protocols":["http","https"],
#     "created_at":1599230674,
#     "snis":null,
#     "service":{"id":"33bd5149-6256-41b7-acb4-ad32ef08c0fb"},
#     "name":null,
#     "strip_path":true,
#     "preserve_host":false,
#     "regex_priority":0,
#     "updated_at":1599230674,
#     "sources":null,
#     "methods":null,
#     "https_redirect_status_code":426,
#     "hosts":["example.com"],
#     "tags":null
# }

# AWS --------  make a rout version instead
curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'paths[]=/example-service/'


# Forward your requests trough Kong
curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'

# Response too long to copy but got the front page from http://mockbin.org

# USING api-manager-service ---------------------------------------------------
# dave-test-api ------------------------------
curl -i -X POST \
  --url http://localhost:8000/services/ \
  --header "Host: api-manager.org" \
  --data 'name=dave-test-api' \
  --data 'url=http://httpbin.org/'
# Response
# {"host":"httpbin.org","id":"d84120a2-d03b-4b9a-ac08-1c55b78fbacb","protocol":"http","read_timeout":60000,"tls_verify_depth":null,"port":80,"updated_at":1599857087,"ca_certificates":null,"created_at":1599857087,"connect_timeout":60000,"write_timeout":60000,"name":"dave-test-api","retries":5,"path":"\/","tls_verify":null,"client_certificate":null,"tags":null}%

# Davetestapi route
curl -i -X POST \
  --url http://localhost:8000/services/dave-test-api/routes \
  --header "Host: api-manager.org" \
  -d "name=dave-test-route" \
  -d "paths[]=/davetestapi"
# Response
# {"id":"4a31b21d-16d7-467f-8706-d961606395f3",
# "path_handling":"v0","paths":["\/davetestapi"],"destinations":null,"headers":null,"protocols":["http","https"],"created_at":1599857483,"snis":null,"service":{"id":"d84120a2-d03b-4b9a-ac08-1c55b78fbacb"},"name":"dave-test-route","strip_path":true,"preserve_host":false,"regex_priority":0,"updated_at":1599857483,"sources":null,"methods":null,"https_redirect_status_code":426,"hosts":null,"tags":null}



# ---------------------------------------------------  CONSUMER calls

## Provision a key credential for that consumer.  KEY IS OLD  WONT WORK NOW
curl -i -X POST \
  --url http://localhost:8001/consumers/David-Caldwell/key-auth/ \
  --data 'key=06104FC3-0A62-4759-8606-8F3011441022'
# Response
# {
#     "created_at":1599247074,
#     "consumer":{"id":"34e7edd3-413b-4404-9c6d-3ccb517fa8c4"},
#     "id":"a61323b6-90ed-4b35-bb39-7a4602a0a810",
#     "tags":null,
#     "key":"06104FC3-0A62-4759-8606-8F3011441022"
# }

# Verify the credentials:
$ curl -i -X GET \
  --url http://localhost:8000 \
  --header "Host: example.com" \
  --header "apikey: 06104FC3-0A62-4759-8606-8F3011441022"
# Response
# Too long again it's the httpbin.org page..

# enabling Key-auth Plugin. for
curl -i -X POST \
  --url http://localhost:8001/services/example-service/plugins/ \
  --data 'name=key-auth'