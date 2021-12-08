terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.45.0"  #mention the provider information version here.
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}