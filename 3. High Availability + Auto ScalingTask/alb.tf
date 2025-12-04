resource "aws_lb" "vishnu_pandey_alb" {
  name               = "vishnu-pandey-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vishnu_pandey_alb_sg.id]
  subnets            = aws_subnet.vishnu_pandey_public_subnet[*].id

  tags = {
    Name = "vishnu_pandey_alb"
  }
}

resource "aws_lb_target_group" "vishnu_pandey_tg" {
  name     = "vishnu-pandey-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vishnu_pandey_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "vishnu_pandey_tg"
  }
}

resource "aws_lb_listener" "vishnu_pandey_listener" {
  load_balancer_arn = aws_lb.vishnu_pandey_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vishnu_pandey_tg.arn
  }
}