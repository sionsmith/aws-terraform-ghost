# IAM Policies

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

resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "writetocloudwatch" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

