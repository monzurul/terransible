resource "aws_s3_bucket" "codepipelinebucket" {
  bucket = "${var.project_name}-${var.environment}-codepipeline"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-${var.environment}-codepipeline-role"

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

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project_name}-${var.environment}-codepipeline-policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "s3:ListBucket",
                "s3:GetBucketPolicy",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.project_name}-${var.environment}-codepipeline*"
            ]
        },
        {
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.project_name}-${var.environment}-codepipeline*",
                "arn:aws:s3:::ec2*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:ResumeProcesses",
                "autoscaling:SuspendProcesses",
                "cloudformation:GetTemplate",
                "cloudformation:DescribeStackResource",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "ec2:DescribeInstances",
                "ec2:DescribeImages",
                "ec2:DescribeAddresses",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeKeyPairs",
                "elasticloadbalancing:*",
                "rds:DescribeDBInstances",
                "rds:DescribeOrderableDBInstanceOptions",
                "sns:ListSubscriptionsByTopic"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "lambda:invokefunction",
                "lambda:listfunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketPolicy",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::ec2*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_codepipeline" "backend-projectA" {
  name     = "${var.project_name}-backend-${var.environment}"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipelinebucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration {
        OAuthToken = "${var.github_per_token}"
        PollForSourceChanges = "true"
        Owner      = "monzurul"
        Repo       = "django_backend"
        Branch     = "${var.code_pipeline_backend_branch}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration {
        ApplicationName = "${var.project_name}-backend-${var.environment}"
        DeploymentGroupName = "${var.project_name}-backend-${var.environment}"
      }
    }
  }
}

resource "aws_codepipeline" "frontend-projectA" {
  name     = "${var.project_name}-frontend-${var.environment}"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipelinebucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration {
        OAuthToken = "${var.github_per_token}"
        PollForSourceChanges = "true"
        Owner      = "monzurul"
        Repo       = "react_frontend"
        Branch     = "${var.code_pipeline_frontend_branch}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration {
        ApplicationName = "${var.project_name}-frontend-${var.environment}"
        DeploymentGroupName = "${var.project_name}-frontend-${var.environment}"
      }
    }
  }
}
