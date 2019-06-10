# IAM Role Swarm manager related resources

data "aws_iam_policy_document" "swarm_manager_ecr" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "swarm_manager_ebs" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteVolume",
      "ec2:DeleteSnapshot",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeSnapshots",
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DetachVolume",
      "ec2:ModifySnapshotAttribute",
      "ec2:ModifyVolumeAttribute",
      "ec2:DescribeTags"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "swarm_manager_secrets" {
  statement {
    actions = [
      "secretsmanager:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "swarm_manager" {
  name               = "orbs-constellation-${var.name}-manager"
  assume_role_policy = "${data.aws_iam_policy_document.swarm_manager_role.json}"
}

data "aws_iam_policy_document" "swarm_manager_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "swarm_manager" {
  name  = "swarm-manager-${var.name}-profile"
  role = "${aws_iam_role.swarm_manager.name}"
}

resource "aws_iam_policy" "swarm_manager_secrets" {
  name   = "orbs-constellation-${var.name}-secrets-manager-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.swarm_manager_secrets.json}"
}

resource "aws_iam_policy" "swarm_manager_ecr" {
  name   = "orbs-constellation-${var.name}-ecr-manager-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.swarm_manager_ecr.json}"
}

resource "aws_iam_policy" "swarm_manager_ebs" {
  name   = "orbs-constellation-${var.name}-ebs-manager-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.swarm_manager_ebs.json}"
}

resource "aws_iam_policy_attachment" "swarm_manager_ecr" {
  name       = "swarm-manager-${var.name}-ecr-iam-policy-attachment"
  roles      = ["${aws_iam_role.swarm_manager.name}"]
  policy_arn = "${aws_iam_policy.swarm_manager_ecr.arn}"
}

resource "aws_iam_policy_attachment" "swarm_manager_ebs" {
  name       = "swarm-manager-${var.name}-ebs-iam-policy-attachment"
  roles      = ["${aws_iam_role.swarm_manager.name}"]
  policy_arn = "${aws_iam_policy.swarm_manager_ebs.arn}"
}

resource "aws_iam_policy_attachment" "swarm_manager_secrets" {
  name       = "swarm-manager-${var.name}-secrets-iam-policy-attachment"
  roles      = ["${aws_iam_role.swarm_manager.name}"]
  policy_arn = "${aws_iam_policy.swarm_manager_secrets.arn}"
}
