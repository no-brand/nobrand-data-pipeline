variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "aws_shared_credentials_file" {
  description = "aws credentials path"
  type        = string
}

variable "aws_profile" {
  description = "aws profile"
  type        = string
}

variable "project" {
  description = "project prefix"
  type        = string
}

variable "sfn_definition_file" {
  description = "aws step function definition"
  default     = "step_function.json"
}

variable "emr_access_key_name" {
  description = "name of ec2 key pair to access ssh to master node"
}