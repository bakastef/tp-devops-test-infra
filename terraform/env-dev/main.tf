provider "aws" {
  region                  = var.aws-region
  version                 = "~> 2.2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.tf-profile
}

provider "terraform" {}

/* Can't setup remote states, no S3 access
terraform {

  backend "s3" {
    encrypt = true
    bucket = "remote-state-storage"
    dynamodb_table = "tf-remote-state-lock"
    region = "us-west-2"
    key = "dev/terraform.tfstate"
  }
}
*/



module "tp-devops-test" {

    source = "../modules/tp-test"

    vpc-id = "vpc-7932a701"
    subnet-ids = {
      "subnet-az-a": "subnet-6e151625",
      "subnet-az-b": "subnet-6331d71b",
      "subnet-az-c": "subnet-fb4cbda6"
    }
}