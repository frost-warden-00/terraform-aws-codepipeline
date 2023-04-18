data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid = "codepipeline"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      data.aws_s3_bucket.codepipeline.arn,
      "${data.aws_s3_bucket.codepipeline.arn}/*",
    ]
  }

  statement {
    sid = "codepipeline2"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "codepipeline3"
    resources = [
      data.aws_codecommit_repository.project.arn
    ]

    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:ListBranches",
      "codecommit:ListRepositories",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus"
    ]
  }

  statement {
    sid = "codepipeline4"

    actions = [
      "s3:*"
    ]
    resources = [
      data.aws_s3_bucket.output_artifact.arn,
      "${data.aws_s3_bucket.output_artifact.arn}/*",
    ]
  }

  statement {
    sid = "codepipeline5"

    actions = [
      "codedeploy:*",
      "ecr:*",
      "ecs:*",
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "Secrets"

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "codepipeline" {
  name   = "${local.prefix}codepipeline"
  path   = "/"
  policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "aws_iam_role" "codepipeline" {
  name = "${local.prefix}codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}