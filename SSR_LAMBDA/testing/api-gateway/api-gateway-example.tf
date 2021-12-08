terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.45.0"  #mention the provider information version here.
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}


#Creating a API gateway resource for SSR Lambda
resource "aws_api_gateway_rest_api" "SSR_Test" {
  name        = "SSR_Test"
  description = "Terraform API Gateway for Lambda SSR"
}

#create a API gateway resource
resource "aws_api_gateway_resource" "SSR_Test" {
   rest_api_id = aws_api_gateway_rest_api.SSR_Test.id
   parent_id   = aws_api_gateway_rest_api.SSR_Test.root_resource_id
   path_part   = "{proxy+}"
}

#Create API method POST for the above created resource  proxy
resource "aws_api_gateway_method" "SSR_Test" {
   rest_api_id   = aws_api_gateway_rest_api.SSR_Test.id
   resource_id   = aws_api_gateway_resource.SSR_Test.id
   #http_method   = "POST" #actual implementation for SSR.
   http_method = "POST"
   authorization = "NONE"
}

#Create a method response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.SSR_Test.id
  resource_id = aws_api_gateway_resource.SSR_Test.id
 http_method = aws_api_gateway_method.SSR_Test.http_method
 status_code = "200"
}

#Create an api integration with lambda
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.SSR_Test.id
   resource_id = aws_api_gateway_method.SSR_Test.resource_id
   http_method = aws_api_gateway_method.SSR_Test.http_method
   #integration_http_method = "POST" #this is for actual one
   integration_http_method = "POST"
   type                    = "AWS_PROXY" #aws proxy helps us to connect API of other aws resources in this case lambda
   uri                     = aws_lambda_function.example.invoke_arn
}






resource "aws_api_gateway_deployment" "SSR_Test" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     #aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.SSR_Test.id
   stage_name  = "test"
}





output "base_url" {
  value = aws_api_gateway_deployment.SSR_Test.invoke_url
}

#to make the api gateway to create cloud watch logs

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}