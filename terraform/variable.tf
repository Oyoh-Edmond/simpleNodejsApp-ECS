variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "project_name" {
  type    = string
  default = "web-app"
}

variable "subnets" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# variable "uri" {
#   type
# }