terraform {
#  cloud {
#    organization = "cac-org"
#    hostname     = "app.terraform.io" # default

#    workspaces {
#      name = "terraform-aws-tfc-workflow"
#    }
#  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      name        = "${var.prefix}-vpc-${var.region}"
      environment = var.environment
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"s3:PutObject"
			],
			"Resource": "arn:aws:s3:::blake-test-1234567",
      "Condition": {
				"StringLike": {
					"aws:userid": "*:Blake"
				}
			}
		}
	  ]
  })
}

#data "aws_security_group" "example" {
#  name                = aws_security_group.hashicat.name
#
#  lifecycle {
#    postcondition {
#    condition = self.name == "blakegroup"
#    error_message = "no match"
#    }
#  }
#}

#check "check_sg_state" {
#  assert {
#    condition = data.aws_security_group.example.name == "blakegroup"
#    error_message = "no match"
#  }
#}

