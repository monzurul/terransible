resource "aws_iam_role" "codedeploy" {
  name = "codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.codedeploy.name}"
}

resource "aws_codedeploy_app" "backend-codedeploy" {
  compute_platform = "Server"
  name             = "${var.project_name}-backend-${var.environment}"
}

resource "aws_sns_topic" "codedeploy-output" {
  name = "codedeploy-output-topic"
}

resource "aws_codedeploy_deployment_group" "backend-codedeploy-group" {
  app_name              = "${aws_codedeploy_app.backend-codedeploy.name}"
  deployment_group_name = "${var.project_name}-backend-${var.environment}"
  service_role_arn      = "${aws_iam_role.codedeploy.arn}"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "${var.project_name}-${var.environment}"
    }
  }

/*   trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "${var.project_name}-backend-${var.environment}-trigger"
    trigger_target_arn = "${aws_sns_topic.codedeploy.arn}"
  }
 */
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

resource "aws_codedeploy_app" "frontend-codedeploy" {
  compute_platform = "Server"
  name             = "${var.project_name}-frontend-${var.environment}"
}

resource "aws_codedeploy_deployment_group" "frontend-codedeploy-group" {
  app_name              = "${aws_codedeploy_app.frontend-codedeploy.name}"
  deployment_group_name = "${var.project_name}-frontend-${var.environment}"
  service_role_arn      = "${aws_iam_role.codedeploy.arn}"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "${var.project_name}-${var.environment}"
    }
  }

  //trigger_configuration {
  //  trigger_events     = ["DeploymentFailure"]
  //  trigger_name       = "${var.project_name}-frontend-${var.environment}-trigger"
  //  trigger_target_arn = "${aws_sns_topic.codedeploy.arn}"
  //}

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
