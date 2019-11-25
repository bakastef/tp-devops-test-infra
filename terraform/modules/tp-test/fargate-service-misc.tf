

# Container logs to cloudwatch
resource "aws_cloudwatch_log_stream" "logs-stream-testing" {

  depends_on = [aws_cloudwatch_log_group.logs-grp-fargate]

  name           = "task-testing"
  log_group_name = aws_cloudwatch_log_group.logs-grp-fargate.name
}


# Settign up the ALB listener, rule and targetgroup
resource "aws_alb_target_group" "alb-tgrp-testing" {

  name     = "${var.env-prefix}tgrp-testing"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  target_type = "ip"
  deregistration_delay = 10

  health_check {
    interval            = 15
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb_listener_rule" "alb-listener-rule-testing" {

  depends_on    = [aws_alb_target_group.alb-tgrp-testing]

  listener_arn  = aws_alb_listener.alb-listener-80.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-tgrp-testing.arn
  }
  condition {
    field  = "host-header"
    //values = [aws_route53_record.r53-record-alb-public-hello.fqdn]
    values = [aws_alb.alb-public.dns_name]
  }
}