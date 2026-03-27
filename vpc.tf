provider "aws" {
  region = "ap-northeast-2"
}

data "aws_internet_gateway" "default" {
  filter {
    name = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}