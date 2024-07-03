resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform  = var.compute_platform
  name              = var.codedeploy_project_name
  tags              = tomap(var.tags)
}

resource "aws_codedeploy_deployment_config" "codedeploy_project_config" {
  deployment_config_name = "${var.codedeploy_project_name}-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  } 
}

resource "aws_codedeploy_deployment_group" "codeploy_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "${aws_codedeploy_app.codedeploy_app.name}-deployment-group"
  service_role_arn      = var.codedeploy_service_role_arn

  ec2_tag_filter {
    key     = var.key_tag_filter
    type    = var.type_tag_filter
    value   = var.value_tag_filter
  }
}