#
# resource "aws_iam_role_policy" "policy" {
#   name        = "${var.prefix}-test-policy"
#   role = aws_iam_role.test_role.id

#   policy = jsonencode({
# 	"Version": "2012-10-17",
# 	"Statement": [
# 		{
# 			"Sid": "VisualEditor0",
# 			"Effect": "Allow",
# 			"Action": [
# 				"s3:PutObject"
# 			],
# 			"Resource": [
#         "arn:aws:s3:::blake-test-1234567",
#         "arn:aws:s3:::blake-test-1234567/*"
#       ]
#       "Condition": {
# 				"StringLike": {
# 					"aws:userid": "*:${var.user-id}"
# 				},
#         "DataLessThan": {
# 					"aws:CurrentTime": "${var.session-time}"
# 				},
# 			}
# 		}
# 	  ]
#   })
# }

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



# data "aws_security_group" "example" {
#  name                = aws_security_group.hashicat.name
#
#  lifecycle {
#    postcondition {
#    condition = self.name == "blakegroup"
#    error_message = "no match"
#    }
#  }
# }

# check "check_sg_state" {
#  assert {
#    condition = data.aws_security_group.example.name == "blakegroup"
#    error_message = "no match"
#  }
# }



# variable "address_space" {
#   description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
#   default     = "10.0.0.0/16"
# }

# variable "subnet_prefix" {
#   description = "The address prefix to use for the subnet."
#   default     = "10.0.10.0/24"
# }

# variable "instance_type" {
#   description = "Specifies the AWS instance type."
#   default     = "t3.micro"
# }

# variable "height" {
#   default     = "400"
#   description = "Image height in pixels."
# }

# variable "width" {
#   default     = "600"
#   description = "Image width in pixels."
# }

# variable "placeholder" {
#   default     = "placekitten.com"
#   description = "Image-as-a-service URL. Some other fun ones to try are fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com, placedog.net"
# }

# variable "environment" {
#   type        = string
#   description = "Define infrastructure’s environment"
#   default     = "dev"
#   validation {
#     condition     = contains(["dev", "qa", "prod"], var.environment)
#     error_message = "The environment value must be dev, qa, or prod."
#   }
# }