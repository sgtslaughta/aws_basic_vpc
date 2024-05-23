variable "project_shortname" {
  description = "Short name of the project"
  type        = string
  default     = "aws-terraform-project"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "default_project"
}

variable "additional_tags" {
  default = {
    Environment = "default"
    Owner       = "richard"
    Project     = "default_project"
  }
  description = "Additional resource tags"
  type        = map(string)
}