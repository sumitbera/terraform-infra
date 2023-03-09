# -------- iamrole/main.tf --------

data "aws_iam_policy_document" "ecs_agent_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent_role" {
  name= var.ecs_agent_role
  assume_role_policy = data.aws_iam_policy_document.ecs_agent_policy.json
}

resource "aws_iam_instance_profile" "ecs_agent_profile" {
  name = var.ecs_agent_profile
  role = aws_iam_role.ecs_agent_role.name
}