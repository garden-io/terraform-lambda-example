variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = "Lambda function created with Terraform"
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "nodejs18.x"
}

variable "handler" {
  description = "Handler function for Lambda"
  type        = string
  default     = "index.handler"
}

variable "memory_size" {
  description = "Amount of memory in MB for the Lambda function"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout in seconds for the Lambda function"
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to attach to the Lambda function"
  type        = map(string)
  default     = {}
}

# IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name_prefix = "${var.function_name}-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Lambda function
resource "aws_lambda_function" "function" {
  filename         = "${path.root}/function.zip"
  function_name    = var.function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = var.handler
  runtime         = var.runtime
  description     = var.description
  memory_size         = var.memory_size
  timeout             = var.timeout
  environment {
    variables = var.environment_variables
  }
  tags = var.tags

}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.function.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.function.function_name
}

output "function_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.arn
}

output "function_role_name" {
  description = "Name of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.name
}
