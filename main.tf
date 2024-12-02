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



