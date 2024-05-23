terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
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

