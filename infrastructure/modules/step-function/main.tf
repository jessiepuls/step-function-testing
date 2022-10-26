resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.fn_name
  role_arn = aws_iam_role.step_function_role.arn

  definition = <<EOF
  {
    "Comment": "Invoke AWS Lambda from AWS Step Functions with Terraform",
    "StartAt": "HelloWorld",
    "States": {
      "HelloWorld": {
        "Type": "Task",
        "Resource": "${var.lambda_arn}",
        "End": true
      }
    }
  }
  EOF
}

resource "aws_iam_role" "step_function_role" {
  name               = "${var.fn_name}-role"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "StepFunctionAssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "step_function_policy" {
  name    = "${var.fn_name}-policy"
  role    = aws_iam_role.step_function_role.id

  policy  = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": "${var.lambda_arn}"
      }
    ]
  }
  EOF
}