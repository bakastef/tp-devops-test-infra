/**  =============================================================== */
# Environemnet related variables

variable "aws-environment" {
    type    = string
    default = "test"
}

variable "env-prefix" {
    type    = string
    default = "tptest-"
}

variable "resource-owner" {
    type    = string
    default = "terraform"
}

variable "tf-profile" {
    default = "default"
}

variable "aws-region" {
    type    = string
    default = "us-west-2"
}





/**  =============================================================== */
# Module required variables 
variable "vpc-id" {
    type    = string
}

variable "subnet-ids" {
    type    = map
}



/**  =============================================================== */
# Fargate variables
variable "ecs-service-nb-instances" {
    type    = number
    default = 2
}
variable "aws-ecs-fargate-task-cpu" {
    type    = number
    default = 512
}
variable "aws-ecs-fargate-task-memory" {
    type    = number
    default = 1024
}
variable "aws-ecs-fargate-task-memory-reservation" {
    type    = number
    default = 128
}
