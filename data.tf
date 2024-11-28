data "aws_iam_policy_document" "cac-policy" {
  statement {
    sid = "1"

    actions = [
      "s3:PutObject",
    ]

    resources = [
        "arn:aws:s3:::blake-test-1234567",
        "arn:aws:s3:::blake-test-1234567/*",
    ]

    condition {
      test     = "StringLike"
      variable = "aws:userid"
      values   = ["*:${var.user-id}"]
    }
#
    # condition {
    #   test     = "DataLessThan"
    #   variable = "aws:CurrentTime"
    #   values   = ["${var.session-time}"]
    # }
  }
}