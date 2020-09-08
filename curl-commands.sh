

# EXAMPLE ------------------------------------------ SERVICE CALLS
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

# Forward your requests trough Kong
curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'

# Response too long to copy but got the front page from http://mockbin.org


# ---------------------------------------------------  CONSUMER calls
## Create a Consumer....
curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=David-Caldwell"
# Response
# {
#     "custom_id":null,
#     "created_at":1599236454,
#     "id":"34e7edd3-413b-4404-9c6d-3ccb517fa8c4",
#     "tags":null,
#     "username":"David-Caldwell"
# }

## Provision a key credential for that consumner.
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

