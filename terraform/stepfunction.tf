resource "aws_iam_role" "iam_role_sfn" {
  name               = "${var.project}_iam_role_sfn"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Sid: "",
        Effect: "Allow",
        Principal: {
          Service: "states.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_role_policy_sfn" {
  name   = "${var.project}_iam_role_policy_sfn"
  role   = aws_iam_role.iam_role_sfn.id
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "lambda:InvokeFunction"
        ],
        Resource: "*"
      },
      {
        Effect: "Allow",
        Action: [
          "elasticmapreduce:RunJobFlow",
          "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:TerminateJobFlows"
        ],
        Resource: "arn:aws:elasticmapreduce:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/*"
      },
      {
        Effect: "Allow",
        Action: [
          "iam:GetRole",
          "iam:PassRole"
        ],
        Resource: [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EMR_DefaultRole",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EMR_EC2_DefaultRole"
        ]
      }
    ]
  })
}

data "template_file" "sfn_definition" {
  template = file(var.sfn_definition_file)
  vars     = {
    log_s3_path = "${aws_s3_bucket.s3_bucket_emr.bucket}/${var.aws_region}"
  }
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name       = "${var.project}_sfn_state_machine"
  definition = data.template_file.sfn_definition.rendered
  role_arn   = aws_iam_role.iam_role_sfn.arn
}
