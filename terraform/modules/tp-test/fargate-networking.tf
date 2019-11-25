/**
To work around the CannotPullContainerError error, and the unability to create custom IAM policies (giving Faragte access to ECR)
I've tried to create here 3 nat gateways (1 per subnet/AZ) and a set of route table to give Fargate services access to internet.


>> https://aws.amazon.com/premiumsupport/knowledge-center/ecs-pull-container-api-error-ecr/
I tried to get it to work for way too long, but it didn't work. Allocating a public IP to the running tasks is a way worst solution, but it did the trick.
*/



/*
resource "aws_eip" "nat-static-ip" {

  vpc = true
  count = 3

  tags = {
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
    Name = "${var.env-prefix}public-static-ip${count.index}"
  }
}


resource "aws_nat_gateway" "nat-static-ip" {

  count = 3
  allocation_id = aws_eip.nat-static-ip[count.index].id
  subnet_id     = local.subnet-ids[count.index]

  tags = {
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
    Name = "${var.env-prefix}nat-static-ip-${count.index}"
  }
}



resource "aws_route_table" "rt-fargate-internet-outbound" {

  count = 3
  vpc_id = var.vpc-id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-static-ip[count.index].id
  }

  tags = {
    Name = "rt-fargate-outbound-traffic-${count.index}"
  }
}

resource "aws_route_table_association" "rt-fargate-association" {
  count = 3

  subnet_id      = local.subnet-ids[count.index]
  route_table_id = aws_route_table.rt-fargate-internet-outbound[count.index].id
}
*/

/*
resource "aws_default_route_table" "r" {

  default_route_table_id = data.aws_vpc.main-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-static-ip[1].id
  }

  tags = {
    Name = "default table"
  }
}
*/