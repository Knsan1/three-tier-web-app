variable "aws_region" {
  description = "The AWS region where AWS resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "network-three-tier-devopshacks-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "RetrieveUserData"
}

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = "UserRequestAPI"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "UserData"
}


variable "project_name" {
  description = "A unique name for the project to prefix the bucket."
  default     = "three-tier-web-app"
}