resource "aws_security_group" "vishnu_pandey_alb_sg" {
  name        = "vishnu_pandey_alb_sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vishnu_pandey_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vishnu_pandey_alb_sg"
  }
}

resource "aws_security_group" "vishnu_pandey_ec2_sg" {
  name        = "vishnu_pandey_ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.vishnu_pandey_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.vishnu_pandey_alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vishnu_pandey_ec2_sg"
  }
}