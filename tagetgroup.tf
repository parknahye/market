resource "aws_lb_target_group" "market_target_group" {
  name        = "market-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.nahye_vpc.id

  target_type = "ip"
}
