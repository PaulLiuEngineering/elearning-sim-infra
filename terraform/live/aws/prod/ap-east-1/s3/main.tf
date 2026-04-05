data "aws_iam_policy_document" "https_only_bucket_access" {
  count = var.attach_https_only_bucket_policy ? 1 : 0

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

module "s3" {
  source = "../../../../../modules/s3"

  bucket_name        = var.bucket_name
  versioning_enabled = true
  sse_algorithm      = "AES256"
  bucket_policy      = var.attach_https_only_bucket_policy ? data.aws_iam_policy_document.https_only_bucket_access[0].json : null
  tags               = var.tags
}
