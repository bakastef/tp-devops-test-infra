/**
Since I'm given part ofthe infrastructure, I'm using this "data.tf" file to fetch the resources I'm going to need to build the cluster.
This file is located in the "env" directory and not in the "tp-test" module becaus ethese resources will vary from an environemnt to the other
 */


provider "aws" {
    region                  = var.aws-region
    version                 = "~> 2.2"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = var.tf-profile
}



/**  =============================================================== */
# Networking

data "aws_vpc" "main-vpc"{
    id = var.vpc-id
}

# get the 3 subnets required to configured networking and the ALB
data "aws_subnet" "subnet-az-a" {
    id = lookup(var.subnet-ids, "subnet-az-a")
}
data "aws_subnet" "subnet-az-b" {
    id = lookup(var.subnet-ids, "subnet-az-b")
}
data "aws_subnet" "subnet-az-c" {
    id = lookup(var.subnet-ids, "subnet-az-c")
}



locals {
    subnet-ids   = [data.aws_subnet.subnet-az-a.id, data.aws_subnet.subnet-az-b.id, data.aws_subnet.subnet-az-c.id]
    subnet-cidrs = [data.aws_subnet.subnet-az-a.cidr_block, data.aws_subnet.subnet-az-b.cidr_block, data.aws_subnet.subnet-az-c.cidr_block]
}

