variable "codedeploy_project_name" {
  description = "codedeploy name"
}

variable "codedeploy_service_role_arn" {
  description = "codedeploy service role arn"
}

variable "key_tag_filter" {
  description = "Key tag filter"
  default = "Environment"  
}

variable "type_tag_filter" {
  description = "Type tag filter"
  default = "KEY_AND_VALUE" 
}

variable "value_tag_filter" {
  description = "Value tag filter"
  default = "Test"  
}

variable "compute_platform" {
  description = "compute platform"
  default = "Server"  
}


variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}