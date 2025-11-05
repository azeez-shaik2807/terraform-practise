
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-code-bucket-${random_id.bucket_id.hex}"
  force_destroy = true 

  tags = {
    Name = "aziz-ki-buckett"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# ✅ IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# ✅ Attach Lambda Logging Policy
resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ✅ Lambda Function (uses your uploaded S3 code)
resource "aws_lambda_function" "my_lambda" {
  function_name = "s3-trigger-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"   # Python handler file.function
  runtime       = "python3.9"                        # Change if Node/other

  s3_bucket = "lambda-code-bucket-9d326dd0"                     # ⬅️ Change this
  s3_key    = "lambda_function.zip"                           # ⬅️ Change if your file path/name differs

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs_policy
  ]
}
