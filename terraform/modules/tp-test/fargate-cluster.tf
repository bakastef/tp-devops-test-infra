
/**  =============================================================== */
# Fetch the role I've been asked to use in the test instructions
data "aws_iam_role" "ecstaskExecRole" {
  name = "ecsTaskExecutionRole"
}


/**  =============================================================== */
# Create a custom role & policy for this specific service

/*
I do not have permissions to do so, and that sadly is the source of some of the ECR issues I've been having
Ideally, I would have created something like below: a user & policy that gives me access to ECR straight away

resource "aws_iam_role" "iam-role-ecsTaskExecution" {

  name = "${var.env-prefix}iam-role-ecs-task-exec"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com"] },
    "Action": "sts:AssumeRole"
  }
}
EOF
}

# Gives access toECR, Cloudwatch logs and loadbalancers
resource "aws_iam_role_policy" "iam-policy-ecsTaskExecution" {

  name = "${var.env-prefix}iam-policy-ecsExec"
  role = aws_iam_role.iam-role-ecsTaskExecution.id


  # "elasticloadbalancing:*"  >> test if access to EC2 gives access to the target group   >> ecs:*
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "ecs:*",
              "elasticloadbalancing:CreateTargetGroup",
              "elasticloadbalancing:DescribeListeners",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeTargetGroupAttributes",
              "elasticloadbalancing:DescribeTargetGroups",
              "elasticloadbalancing:DescribeTargetHealth",
              "elasticloadbalancing:ModifyListener",
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:ModifyTargetGroup",
              "elasticloadbalancing:ModifyTargetGroupAttributes",
              "elasticloadbalancing:RegisterTargets"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}
*/




// ============================================================================
// prepare cloudwatch log group/streams for system/container logs

resource "aws_cloudwatch_log_group" "logs-grp-fargate" {

  name = "${var.env-prefix}fargate-containers"
  retention_in_days = 7

  tags = {
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
  }
}


/**
No access to S3 for thi stest, not S3 bucket to expot the logs to

# Addign a S3 bucket to export logs to
resource "aws_s3_bucket" "s3-fargate-logs" {
  bucket = "s3-${var.env-prefix}fargate-cloudwatch-logs"
  acl    = "private"
}


resource "aws_s3_bucket_policy" "s3-fargate-logs-policy" {

  bucket = aws_s3_bucket.s3-fargate-logs.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "s3:GetBucketAcl",
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.s3-fargate-logs.id}",
        "Principal":
          { "Service": "logs.eu-west-1.amazonaws.com"}
    },
    {
        "Action": "s3:PutObject",
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.s3-fargate-logs.id}/*",
        "Condition": { "StringEquals": { "s3:x-amz-acl": "bucket-owner-full-control"}},
        "Principal": { "Service": "logs.eu-west-1.amazonaws.com"}
    }
  ]
}
POLICY
}
*/




// ============================================================================
// Build the Fargate cluster

resource "aws_ecs_cluster" "ecs-fargate-cluster" {

  name = "${var.env-prefix}ecs-fargate-cluster"
  tags = {
    Name = "${var.env-prefix}ecs-fargate-cluster"
    Terraform   = "true"
    Owner       = var.resource-owner
    Environment = var.aws-environment
  }
}