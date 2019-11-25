
resource "aws_ecs_service" "ecs-service-testing" {

  # dependency on IAM to prevent issues during deletion
  depends_on = [
    aws_ecs_cluster.ecs-fargate-cluster,
    aws_ecs_task_definition.ecs-taskdef-testing,
    aws_lb_listener_rule.alb-listener-rule-testing,
    aws_cloudwatch_log_group.logs-grp-fargate,
    aws_cloudwatch_log_stream.logs-stream-testing
  ]

  name                = "${var.env-prefix}ecs-svc-testing"
  cluster             = aws_ecs_cluster.ecs-fargate-cluster.id

  task_definition     = aws_ecs_task_definition.ecs-taskdef-testing.arn
  desired_count       = var.ecs-service-nb-instances
  launch_type         = "FARGATE"
  health_check_grace_period_seconds = 45

  lifecycle {
    ignore_changes    = [desired_count]
  }

  network_configuration {
    security_groups   = [aws_security_group.sg-ecs-default.id]
    subnets           = local.subnet-ids
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn  = aws_alb_target_group.alb-tgrp-testing.arn
    container_name    = "app-testing"
    container_port    = 5000
  }

  deployment_controller {
    type = "ECS"
  }
  deployment_maximum_percent = 400
  deployment_minimum_healthy_percent = 100

  lifecycle {
    // Preparing for the CI pipeline
    //ignore_changes        = [desired_count]
  }
}





// ============================================================================
// Task & container for api-switch-energy

resource "aws_ecs_task_definition" "ecs-taskdef-testing" {

  task_role_arn      = data.aws_iam_role.ecstaskExecRole.arn
  execution_role_arn = data.aws_iam_role.ecstaskExecRole.arn

  family                   = "app-testing"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = (var.aws-ecs-fargate-task-cpu)
  memory = (var.aws-ecs-fargate-task-memory)

  // Could be stored in a json file, template resource or inline. For this test, it really doesn't matter.
  //container_definitions = file("task-definitions/service.json")
  container_definitions = <<EOF
[
  {
    "name": "app-testing",
    "image": "303981612052.dkr.ecr.us-west-2.amazonaws.com/tp-devopstest-image:latest",
    "cpu": ${var.aws-ecs-fargate-task-cpu},
    "memory": ${var.aws-ecs-fargate-task-memory},
    "memoryReservation": ${var.aws-ecs-fargate-task-memory-reservation},
    "essential": true,
    "networkMode": "awsvpc",
    "environment": [],
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ],
    "healthCheck": {
        "command": [ "CMD-SHELL", "curl -f http://localhost:5000/ || exit 1" ],
        "startPeriod": 10,
        "retries": 3,
        "timeout": 5
    },
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.logs-grp-fargate.name}",
            "awslogs-region": "eu-west-1",
            "awslogs-stream-prefix": "${aws_cloudwatch_log_stream.logs-stream-testing.name}"
        }
    }
  }
]
EOF

  lifecycle {
    create_before_destroy = true
    // Preparing for the CI pipeline
    //ignore_changes        = [container_definitions]
  }

  tags = {
    Name = "${var.env-prefix}ecs-taskDef"
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
  }
}