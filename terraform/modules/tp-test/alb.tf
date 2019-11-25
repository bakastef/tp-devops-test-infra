// ============================================================================
// Create a public ALB listening attached to the 3 subnets
// The 3 subnets already existed, and data has been loaded/verified in main. Meaning I can use directly the id or the data resource

resource "aws_alb" "alb-public" {

  idle_timeout    = 60
  internal        = false
  name            = "${var.env-prefix}alb-public"

  security_groups = [ aws_security_group.sg-alb-public.id]
  subnets         = [lookup(var.subnet-ids, "subnet-az-a"), lookup(var.subnet-ids, "subnet-az-b"), lookup(var.subnet-ids, "subnet-az-c")]

  
  enable_deletion_protection = false

  tags = {
    Name = "${var.env-prefix}alb-public"
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
  }
}



// ============================================================================
// Create a listener on port 80 with a default static HTTP response
resource "aws_alb_listener" "alb-listener-80" {

  load_balancer_arn = aws_alb.alb-public.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "You've reached something ! "
      status_code  = "200"
    }
  }
}