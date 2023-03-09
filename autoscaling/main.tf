# -------- autoscaling/main.tf --------

data "aws_ami" "server_ami" {
  most_recent = true
  owners = ["137112412989"]

  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"]
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id = data.aws_ami.server_ami.id
    iam_instance_profile = var.instance_profile
    security_groups = [var.public_sg]
    instance_type = var.instance_type
    user_data = var.user_data_path
}