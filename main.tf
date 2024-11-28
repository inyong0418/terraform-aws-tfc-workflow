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
      name        = "${var.prefix}-iam-policy"
      role = var.role
    }
  }
}

data "aws_iam_policy" "readonly" {
  name     = "ReadOnlyAccess"
}

variable "user-id" {
  description = "User ID for restrict"
  default     = "*"

  validation {
    condition = !contains(["*"], var.user-id)
    error_message = "Do not use *"
  }
}

resource "aws_iam_role_policy" "policy" {
  name        = "${var.prefix}-test-policy"
  role = aws_iam_role.test_role.id

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"s3:PutObject"
			],
			"Resource": [
        "arn:aws:s3:::blake-test-1234567",
        "arn:aws:s3:::blake-test-1234567/*"
      ]
      "Condition": {
				"StringLike": {
					"aws:userid": "*:${var.user-id}"
				}
			}
		}
	  ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "SAML_Developer-1"
#  managed_policy_arns = [data.aws_iam_policy.readonly.arn]
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::851725357209:saml-provider/blake-okta"
            },
            "Action": "sts:AssumeRoleWithSAML",
            "Condition": {
                "StringEquals": {
                    "SAML:aud": "https://signin.aws.amazon.com/saml"
                }
            }
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "readonly-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = data.aws_iam_policy.readonly.arn
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

