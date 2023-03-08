# -------- ecs/main.tf --------


resource "aws_ecs_cluster" "load-test" {
  name = var.cluster_name
  setting {
    name = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name = "dev-cluster"
  }
}

resource "aws_ecs_service" "load-test-service" {
  name = var.service_name
  cluster = aws_ecs_cluster.load-test.id
  desired_count = var.desired_count
  launch_type = var.launch_type
  platform_version = var.platform_version
  network_configuration {
    security_groups = [var.public_sg]
    subnets = var.public_subnets
  }
}