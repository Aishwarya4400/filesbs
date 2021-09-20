resource "aws_lb" "my-elb" { #aws_lb
  name            = "my-elb"
  internal        = false
  load_balancer_type = "application" #removed this
  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.elb-securitygroup.id]

#added health check

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   protocol            = "HTTP"
  #   interval            = 30
  # }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300
  tags = {
    Name = "my-elb"
  }
}

resource "aws_lb_target_group" "test" { #aws_alb_target_group
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance" #removed this

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    path                = "/"
    port                = "80"
    interval            = 30
    matcher             = "200"
  }
}

