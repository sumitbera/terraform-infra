# -------- compute/main.tf --------

data "aws_ami" "server_ami" {
  most_recent = true
  owners = ["137112412989"]

  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"]
  }
}

resource "random_id" "dev-grafana-influxfb-id" {
  byte_length = 2
  count = var.instance_count
}

resource "aws_instance" "dev-grafana-influxdb" {
    count = var.instance_count
    instance_type = var.instance_type
    ami = data.aws_ami.server_ami.id
    key_name = var.key_name

    tags ={
        Name = "dev-grafana-influxdb${random_id.dev-grafana-id[count.index].dec}"
    }
vpc_security_group_ids = [var.public_sg]
subnet_id = var.public_subnets[count.index]
user_data = var.user_data_path
root_block_device {
    volume_size = var.volume_size
}
}