variable "name_prefix" {
  description = "Name prefix for repositories"
  type        = string
}

variable "tags" {
  description = "Common tags for ECR resources"
  type        = map(string)
}