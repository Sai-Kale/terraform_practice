
#Mention the least required priviliges to the lambda here
data "aws_iam_policy_document" "lambda_ssr_policy" {
  
  #List Bucket access to S3 to the given bucket name in variables.tf file
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::terraform-serverless-example-sai",
    ]
  }
  
  #CloudWatch Logs Policy
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = ["arn:aws:logs:*"]
  }

  #CloudTrail activity log policy mention here whenever a lambda is triggered

}


#Below policy helps lambda to assume the role during execution
data "aws_iam_policy_document" "lambda_ssr_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    sid     = ""
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect        = "Allow"
  }
}

