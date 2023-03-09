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

resource "aws_ecs_cluster_capacity_providers" "ecs-provider" {
  cluster_name = aws_ecs_cluster.load-test.id
  capacity_providers = ["FARGATE_SPOT,FARGATE"]

  default_capacity_provider_strategy {
    base =1
    weight = 100
    capacity_provider = "FARGATE"
  }
}