data "aws_iam_policy_document" "${var.user-id}-policy" {
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
    condition {
      test     = "DateLessThan"
      variable = "aws:CurrentTime"
      values   = ["${var.session-time}"]
    }
  }
}