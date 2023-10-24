terraform {
  cloud {
    organization = "terraform-beginner-project"

    workspaces {
      name = "Terrahouse"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
}
provider "random" {
  # Configuration options
}