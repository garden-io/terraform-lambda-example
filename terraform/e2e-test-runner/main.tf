terraform {
  required_version = ">= 0.12"
  backend "s3" {
    # Set in Garden config
    bucket = ""
    key    = ""
    region = ""
  }
}

# Supplied via Garden config
variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

# Supplied via Garden config
variable "zip_version" {
  description = "version of the zip file"
  type        = string
}

# Supplied via Garden config
variable "environment_name" {
  description = "Name of the environment"
  type        = string
}

# Supplied via Garden config
variable "db_host" {
  description = "The DB host name"
  type        = string
}

# Supplied via Garden config
variable "hello_function_name" {
  description = "The name of the hello function that's invoked during testing"
  type        = string
}

# Supplied via Garden config
variable "goodbye_function_name" {
  description = "The name of the goodbye function that's invoked during testing"
  type        = string
}

module "lambda_function" {
  source        = "../modules/lambda"
  function_name = var.function_name

  # Optional configurations
  description         = "e2e test runner"
  memory_size         = 256
  timeout             = 60
  environment_variables = {
    NODE_ENV = "production"
    ZIP_VERSION = var.zip_version
    HELLO_FUNCTION_NAME = var.hello_function_name
    GOODBYE_FUNCTION_NAME = var.goodbye_function_name
  }
  tags = {
    Environment = var.environment_name
  }
}
