/**

Looks like I don't have permissions to access IAM, but I would normally create here an IAM user for the CI environment (Github Actions)
It's very not good practice to use the same user to access the console, terraform the infra and use in the CI/CD pipeline


Sample below:


resource "aws_iam_user" "iam-cicd-api-only" {

  name = "${var.ev-prefix}iam-secrets-readonly-mongo"
  path = "/users/api/"

  tags = {
  }
}
resource "aws_iam_access_key" "iam-api-key-cicd" {
  user    = aws_iam_user.iam-cicd-api-only.name
}
resource "aws_iam_user_policy" "" {
  name = "secrets-readonly-policy-mongo"
  user = aws_iam_user.iam-secrets-readonly-mongo.name

  policy = <<EOF EOF
}


resource "aws_iam_policy_attachment" "" {
  name       = "iam-cicd-api-only-policy-attach"
  users      = [aws_iam_user.iam-cicd-api-only.name]
  policy_arn =
}

*/