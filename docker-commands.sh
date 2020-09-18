
#Docker Opensource Kong.

# AWS Setup commands
sudo yum update
sudo amazon-linux-extras install docker
# sudo yum install docker # redundant?
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo shutdown -r now # may need to restart
docker info
# -------------------------------------- Ready to install the Docker


# setup for the Docker on my system, now aws
# tried the Cassandra version first, there is a PostgreS version too.
docker network create kong-net

docker run -d --name kong-database \
               --network=kong-net \
               -p 9042:9042 \
               cassandra:3

docker run --rm \
     --network=kong-net \
     -e "KONG_DATABASE=cassandra" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
     kong:latest kong migrations bootstrap
# AWS  -> getting failure here, it feels like it's not getting comms with the kong-database and locking up the command
# because the last call hangs on AWS but worked fine on my system in docker.
# AWS notes : kong-database ports 7000-7001/tcp, 7199/tcp, 9160/tcp, 0.0.0.0:9042->9042/tcp
#           : kong-latest ports 0.0.0.0:8000->8000/tcp, 127.0.0.1:8001->8001/tcp, 0.0.0.0:8443->8443/tcp, 127.0.0.1:8444->8444/tcp

docker run -d --name kong \
     --network=kong-net \
     -e "KONG_DATABASE=cassandra" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
     -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
     -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
     -p 8000:8000 \
     -p 8443:8443 \
     -p 127.0.0.1:8001:8001 \
     -p 127.0.0.1:8444:8444 \
     kong:latest

curl -i http://localhost:8001/
# Got a response it appears running


