output "codedeploy_app_name" {
  value = aws_codedeploy_app.codedeploy_app.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.codeploy_group.deployment_group_name
}