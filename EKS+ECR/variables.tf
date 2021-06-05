variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster-name" {
  default = "terraform-eks-cluster-1"
  type    = string
}

variable "node-group-name" {
  type    = string
  default = "cluster-node-1"
}

variable "instance_types" {
  type    = string
  default = "t3.medium"
}

variable "scaling-desired" {
  type    = string
  default = "1"
}

variable "scaling-max" {
  type    = string
  default = "1"
}

variable "scaling-min" {
  type    = string
  default = "1"
}

variable "ecr-repo-name" {
  type        = string
  description = "Repository name on AWS ECR"
}

variable "ecr-tag-mutability" {
  type        = string
  description = "Can image tags be overwritten or not"
  default     = "IMMUTABLE"
}

variable "scan-on-push" {
  type    = bool
  default = true
}