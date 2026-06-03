data "aws_route53_zone" "main" {
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "records" {
  for_each = var.records

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}