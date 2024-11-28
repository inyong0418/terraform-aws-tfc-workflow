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

resource "aws_iam_policy" "cac-policy" {
  name     = "cac-policy"
  policy = data.aws_iam_policy_document.cac-policy.json
}

# data "aws_iam_policy_document" "cac-policy" {
#   statement {
#     sid = "1"

#     actions = [
#       "s3:PutObject",
#     ]

#     resources = [
#         "arn:aws:s3:::blake-test-1234567",
#         "arn:aws:s3:::blake-test-1234567/*",
#     ]

#     condition {
#       test     = "StringLike"
#       variable = "aws:userid"
#       values   = ["*:${var.user-id}"]
#     }

#     condition {
#       test     = "DataLessThan"
#       variable = "aws:CurrentTime"
#       values   = [var.session-time]
#     }
#   }
# }

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

resource "aws_iam_role_policy_attachment" "cac-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.cac-policy.arn
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

