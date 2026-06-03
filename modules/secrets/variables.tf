variable "name_prefix" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}