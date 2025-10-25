resource "aws_lambda_function" "visitor_counter" {
  function_name = var.lambda_function_name
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 10

  filename         = "lambda_function:v1.2.zip"
  source_code_hash =  data.archive_file.lambda_zip.output_base64sha256
  depends_on = [ data.archive_file.lambda_zip ]

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }
}

# Use templatefile to render the Lambda code before zipping
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function:v1.2.zip"
  source_dir  = "${path.module}/lambda_package"

  # source {
  #   # Render the Lambda handler with the correct region
  #   content = templatefile("${path.module}/template/script.js.tpl", {
  #   })
  #   filename = "index.js"
  # }
}


resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "dynamodb_lambda_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ]
      Effect   = "Allow"
      Resource = aws_dynamodb_table.user_data.arn
    }]
  })
}

