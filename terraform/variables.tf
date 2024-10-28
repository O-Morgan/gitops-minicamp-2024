variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "environment" {
  description = "Environment for tagging and configuration"
  type        = string
  default     = "development"  # Set "development" as the default value
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}
