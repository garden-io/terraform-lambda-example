# main.tf
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-state-for-dev-testing"
    key    = "dev-state-default/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "hello" {
  source = "./modules/hello"
  name   = var.name
}

module "lambda_function" {
  source        = "./modules/lambda-hello"
  function_name = "lambda-hello"
  
  # Optional configurations
  description           = "My Node.js Lambda function"
  memory_size          = 256
  timeout             = 60
  environment_variables = {
    NODE_ENV = "production"
  }
  tags = {
    Environment = "production"
  }
}

output "message" {
  value = module.hello.message
}
