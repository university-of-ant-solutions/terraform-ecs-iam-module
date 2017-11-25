output "ecs_profile_id" {
  value = "${aws_iam_instance_profile.ecs_profile.id}"
}

output "ecs_profile_arn" {
  value = "${aws_iam_role.ecs_instance_role.arn}"
}
