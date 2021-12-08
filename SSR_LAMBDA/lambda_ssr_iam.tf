resource "aws_iam_role_policy" "lambda_ssr_policy" {
  name = "lambda_ssr_policy"
  role = "${aws_iam_role.lambda_ssr_assume_role.id}"  #Lambda takes the below assume role "lambda_ssr_assume_role"

  policy = data.aws_iam_policy_document.lambda_ssr_policy.json
}

resource "aws_iam_role" "lambda_ssr_assume_role" {
  name = "lambda_ssr_assume_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_ssr_assume_role.json
}

