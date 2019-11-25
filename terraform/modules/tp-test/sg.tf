// ============================================================================
// security group
// allow all HTTP traffic from the vpc and ovo
resource "aws_security_group" "sg-alb-public" {

  name        = "${var.env-prefix}sg-alb-public"
  description = "Allow traffic in the public loadbalancer"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [data.aws_vpc.main-vpc.cidr_block]
  }

  tags = {
    Name        = "${var.env-prefix}sg-alb-public"
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
  }
}



resource "aws_security_group" "sg-ecs-default" {

  name = "${var.env-prefix}sg-ecs-default"
  description = "Allow all traffic inside the Fargate cluster"
  vpc_id = var.vpc-id

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = local.subnet-cidrs
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = local.subnet-cidrs
  }

  //workaround the CannotPullContainerError
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env-prefix}sg-ecs-default"
    Terraform = "true"
    Owner = var.resource-owner
    Environment = var.aws-environment
  }
}