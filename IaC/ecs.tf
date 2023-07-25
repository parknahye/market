# cluster
resource "aws_ecs_cluster" "new_market_cluster" {
  name = "new_market_cluster"
}

# service
# user
resource "aws_ecs_service" "market_service" {
  name            = "market_service"
  cluster         = aws_ecs_cluster.new_market_cluster.id
  task_definition = aws_ecs_task_definition.market_task_definition.id
  enable_execute_command = true
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups = [aws_security_group.market_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.market_target_group.arn
    container_name = "market_container"
    container_port = 9000
  }

  depends_on = [
    aws_lb_listener.market_elb_listener,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment_1
  ]

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer
    ]
  }
}


