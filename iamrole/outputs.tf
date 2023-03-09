# -------- iamrole/output.tf ------------

output "instance_profile"{
    value = aws_iam_instance_profile.ecs_agent_profile.id
}