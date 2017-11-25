variable "environment" {}

variable "iam_role_name" {
  default = "iam-roles-as1"
  description = "The name of the IAM roles."
}

variable "iam_instance_profile" {
  default = "iam-instance-profile-as1"
  description = "The name of the IAM instance profile."
}

variable "service_name" {
  description = "The name of the service."
}
