#!/bin/bash
# Installing Grafana
sudo yum update -y
cat <<EOF |  sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
sudo yum install grafana -y
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
sleep 5
#Installing InfluxDb
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL 7
baseurl = https://repos.influxdata.com/rhel/7/x86_64/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF
sudo yum install influxdb -y
sudo systemctl daemon-reload
sudo systemctl start influxdb
curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE jmeter"
sudo systemctl enable influxdb
sleep 5
sudo sed -i '413,418s/.*#//' /etc/influxdb/influxdb.conf
sudo sed -i '425s/.*#//' /etc/influxdb/influxdb.conf
sudo sed -i '428s/.*#//' /etc/influxdb/influxdb.conf
sudo sed -i '431s/.*#//' /etc/influxdb/influxdb.conf
sudo sed -i '434s/.*#//' /etc/influxdb/influxdb.conf
sudo sed -i '437s/.*#//' /etc/influxdb/influxdb.conf