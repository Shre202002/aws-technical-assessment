resource "aws_launch_template" "vishnu_pandey_lt" {
  name_prefix   = "vishnu-pandey-lt"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.vishnu_pandey_key.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.vishnu_pandey_ec2_sg.id]
  }

  user_data = filebase64("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "vishnu_pandey_instance"
    }
  }
}

resource "aws_autoscaling_group" "vishnu_pandey_asg" {
  name_prefix          = "vishnu-pandey-asg-"
  vpc_zone_identifier  = aws_subnet.vishnu_pandey_private_subnet[*].id
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  target_group_arns    = [aws_lb_target_group.vishnu_pandey_tg.arn]

  launch_template {
    id      = aws_launch_template.vishnu_pandey_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "vishnu_pandey_asg_instance"
    propagate_at_launch = true
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "vishnu_pandey_key" {
  key_name   = "vishnu_pandey_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCU0psELucFow+jlyF+/5uiLdI+BNMu2BBIIxaH6ktkWsadq9Ft7BYO2lQPAeGmHBPCs+B2BeePRETEnvM+LmxVKL11neVJiraUjvFnpF86nMkjd2WChahvGJ6VZmocVqUOciYmvQVwqaINlq92cuBDfoe5zzfcWWocZ/r5owi3sIHz8AC3NWYziLahJbrdbH6sZalpSjOxkCR5ar9LdLPqjysvoKbtqP5NDSbPbWZIC88bBBz2RV2xDm+RONN1ELxYp6WQU+DEqiXGCah5QDOjjCjdRBodM3DAEhnhpqPXY5oXd+tS2/OHa1WNtrIT/Q7KAzfBswSwMrcmgWOMrhsz vishnupandey@fedora"
}