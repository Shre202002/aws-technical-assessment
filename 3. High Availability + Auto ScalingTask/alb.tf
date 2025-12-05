resource "aws_lb" "Sriyansh_alb" {
  name               = "vishnu-pandey-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Sriyansh_alb_sg.id]
  subnets            = aws_subnet.Sriyansh_public_subnet[*].id

  tags = {
    Name = "Sriyansh_alb"
  }
}

resource "aws_lb_target_group" "Sriyansh_tg" {
  name     = "vishnu-pandey-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Sriyansh_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Sriyansh_tg"
  }
}

resource "aws_lb_listener" "Sriyansh_listener" {
  load_balancer_arn = aws_lb.Sriyansh_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Sriyansh_tg.arn
  }
}
