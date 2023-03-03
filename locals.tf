locals {
  vpc_cidr = "10.16.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "dev-public-sg"
      description = "security group for public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
          description = "SSH"
        }
        grafana = {
          from        = 8088
          to          = 8088
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
          description = "grafana"
        }
        influxdb_1 = {
          from        = 8086
          to          = 8086
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
          description = "influxdb"
        }
        influxdb_2 = {
          from        = 3000
          to          = 3000
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
          description = "influxdb"
        }
      }
      egress = {
        all_traffic = {
          from        = 0
          to          = 0
          protocol    = "-1"
          cidr_blocks = [var.access_ip]
          description = "all traffic"
        }
      }
    }
  }
}