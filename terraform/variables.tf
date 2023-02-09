variable "environment" {
  description = "Tag your AWS resource with environmet variable"
  type        = string
  default     = "Staging"
}

variable "region" {
  description = "Choose region for your infrastracture"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Choose name of your application"
  type        = string
  default     = "ha-crud"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = string
  default     = "2"
}

variable "securitygroup-ingress" {
  description = "CIDR block for ingress rule to restrict access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "password" {
  description = "RDS DB password"
  type        = string
  sensitive  = true
}

variable "public_key" {
  description = "SSH public key for connection to EC2"
  type        = string
}

variable "common_name" {
  description = "Domain name for self-signed certificate"
  type        = string
  default     = "crud.app.com"
}

variable "organization" {
  description = "Organization name for self-signed certificate"
  type        = string
  default     = "ha_app"
}

variable "validity_period_hours" {
  description = "Certificate validity period"
  type        = number
  default     = 168
}
