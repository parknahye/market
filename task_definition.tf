# task definition
# user
resource "aws_ecs_task_definition" "market_task_definition" {
  family                   = "market_task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 3072
  execution_role_arn       = aws_iam_role.ecsIAM.arn
  task_role_arn            = aws_iam_role.ecsIAM.arn
  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
  
  # Created on the first run and then managed by the CD Tool (Bamboo).
  container_definitions = jsonencode(
    [
      # Application Container
      {
        essential = true
        name      = "market_container"
        image     = "${aws_ecr_repository.market_ecr.repository_url}:latest"
        cpu = 0
        portMappings = [
          {
            name = "market_container-9000-tcp"
            protocol      = "tcp"
            appProtocol = "http"
            containerPort = 9000
            hostPort      = 9000
          }
        ]
        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group         = "/ecs/market_task_definition"
            awslogs-region        = "ap-northeast-2",
            awslogs-stream-prefix = "ecs"
          }
        }
        secrets = [
                {
                    name = "AWS_ACCESS_KEY_ID",
                    valueFrom = "arn:aws:secretsmanager:ap-northeast-2:205360167779:secret:secret-dPk9Po:AWS_ACCESS_KEY_ID::"
                },
                {
                    name = "AWS_SECRET_ACCESS_KEY",
                    valueFrom= "arn:aws:secretsmanager:ap-northeast-2:205360167779:secret:secret-dPk9Po:AWS_SECRET_ACCESS_KEY::"
                }
            ]
      }
    ]
  )
}


