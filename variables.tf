variable "name" {}

variable "region" {
  description = "The region you are deploying into"
}

variable "environment" {
  description = "The environment that generally corresponds to the account you are deploying into."
}

variable "bastion_security_group" {
  description = "Security group id of Bastion security group"
  default = ""
}

variable "tags" {
  description = "Tags that are appended"
  type        = map(string)
}

variable "terraform_state_region" {
  description = "AWS region used for Terraform states"
}

variable "corporate_ip" {
  description = "The ip you would want to lock down ssh to and others"
}

//---------------------

variable "vpc_id" {}

variable "citizen_security_group_id" {
  type = string
  default = ""
}

variable "sentry_security_group_id" {
  type = string
  default = ""
}
