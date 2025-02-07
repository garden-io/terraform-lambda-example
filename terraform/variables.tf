# variables.tf
variable "name" {
  type        = string
  description = "Name to echo in the command"
  default     = "World"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}
