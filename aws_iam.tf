# IAM Policies
resource "aws_iam_policy" "ghost_s3_read_only" {
  name   = "GHOST-S3-READ-ONLY"
  path   = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucketUploads",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${local.ghost_resources_bucket_name}"
            ]
        },
        {
            "Sid": "AllObjectActionsLookups",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListObjects"
            ],
            "Resource": [
                "arn:aws:s3:::${local.ghost_resources_bucket_name}/*"
            ]
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "webserver_assume_role" {
  statement {
    principals {
      identifiers = [
        "ec2.amazonaws.com",
        "ssm.amazonaws.com",
      ]

      type = "Service"
    }

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "webserver_kms" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "webserver_role" {
  name               = "GHOST-IAM-ROLE"
  assume_role_policy = data.aws_iam_policy_document.webserver_assume_role.json
}

resource "aws_iam_policy" "webserver_kms" {
  name        = "GHOST-KMS-ACCESS-POLICY"
  description = "Allows the webserver server to access kms keys"
  policy      = data.aws_iam_policy_document.webserver_kms.json
}

resource "aws_iam_instance_profile" "ghost_profile" {
  name = "GHOST-PROFILE"
  role = aws_iam_role.webserver_role.name
}

resource "aws_iam_role_policy_attachment" "webserver_attach_kms" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = aws_iam_policy.webserver_kms.arn
}

resource "aws_iam_role_policy_attachment" "s3_read_only_access" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = aws_iam_policy.ghost_s3_read_only.arn
}

resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "writetocloudwatch" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

