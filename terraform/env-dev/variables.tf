variable "tf-profile" {

    description = "The aws-cli profile you want terraform to use to connect to AWS "
    default     = "default"
}

variable "aws-region" {

    description = "The aws region you want to connect to"
    default     = "us-west-2"
}