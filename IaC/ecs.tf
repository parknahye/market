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
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment_1,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment_5
  ]

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer
    ]
  }
}



resource "aws_appautoscaling_target" "ecs_target" {
  min_capacity = 1
  max_capacity = 2
  resource_id = "service/new_market_cluster/market_service"
  role_arn = aws_iam_role.ecsIAM.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"

  depends_on = [
    aws_ecs_service.market_service
  ]
}

resource "aws_appautoscaling_policy" "ecs_policy_scale_out" {
  name = "scale-out"
  policy_type = "StepScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "PercentChangeInCapacity"
    cooldown = 1
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 50
    }
  }
}