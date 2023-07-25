resource "aws_lb" "market_alb" {
  name               = "marathon-user-alb-tf"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.market_security_group.id]
}

resource "aws_lb_listener" "market_elb_listener" {
  load_balancer_arn = aws_lb.market_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.market_target_group.arn
    type             = "forward"
  }
}
