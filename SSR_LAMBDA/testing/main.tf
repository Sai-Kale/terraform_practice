resource "aws_lambda_function" "ServerlessExample" {
   function_name = "ServerlessExample"

   # The bucket name as created earlier with "aws s3api create-bucket"
   s3_bucket = "terraform-serverless-example-sai"    
   s3_key    = "example.zip"

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = "main.handler"
   runtime = "nodejs10.x"
   #source_code_hash  = "${filebase64sha256("../v${var.app_version}/example.zip")}"
   role = "${aws_iam_role.lambda_ssr_assume_role.arn}"
}
