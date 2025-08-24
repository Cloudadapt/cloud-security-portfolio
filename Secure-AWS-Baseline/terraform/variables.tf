variable "project" { type = string, default = "cloudadapt", description = "Project prefix for naming" }
variable "region"  { type = string, default = "us-east-1", description = "AWS region" }
variable "vpc_cidr" { type = string, default = "10.0.0.0/16" }
variable "public_subnet_cidrs" { type = list(string), default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnet_cidrs" { type = list(string), default = ["10.0.11.0/24", "10.0.12.0/24"] }
variable "allowed_ingress_cidr" { type = string, default = "0.0.0.0/0" }
variable "instance_type" { type = string, default = "t3.micro" }
variable "enable_alb_access_logs" { type = bool, default = false }
variable "alb_logs_bucket" { type = string, default = "" }
