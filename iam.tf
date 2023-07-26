resource "aws_iam_role" "ecsIAM" {
  name               = "ecsIAM"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "createLogGroup" {
  name        = "createLogGroup"
  description = "createLogGroup"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents",
				"logs:DescribeLogStreams"
			],
			"Resource": [
				"arn:aws:logs:*:*:*"
			]
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_1" {
  role       = aws_iam_role.ecsIAM.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_2" {
  role       = aws_iam_role.ecsIAM.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_3" {
  role       = aws_iam_role.ecsIAM.name
  policy_arn = aws_iam_policy.createLogGroup.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_4" {
  role       = aws_iam_role.ecsIAM.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}