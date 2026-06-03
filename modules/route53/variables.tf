variable "zone_name" {
  type = string
}

variable "records" {
  type = map(object({
    name = string
    type = string
    ttl  = number
    records = list(string)
  }))
}