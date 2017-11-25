locals {
  iam_role_name           = "${var.iam_role_name}-${var.environment}-${var.service_name}"
  iam_instance_profile    = "${var.iam_instance_profile}-${var.environment}-${var.service_name}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
# Provides an IAM instance profile.
#
resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${local.iam_instance_profile}"
  path = "/"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

# Why we need ECS instance policies http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# ECS roles explained here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html
# Some other ECS policy examples http://docs.aws.amazon.com/AmazonECS/latest/developerguide/IAMPolicyExamples.html
#
resource "aws_iam_role" "ecs_instance_role" {
  name = "${local.iam_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name = "ecs_instance_role_policy"
  policy = "${file("${path.module}/templates/ecs-instance-role-policy.json")}"
  role = "${aws_iam_role.ecs_instance_role.id}"
}
