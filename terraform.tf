terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "automate6500"

    workspaces {
      name = "tfcloud"
    }
  }
}
