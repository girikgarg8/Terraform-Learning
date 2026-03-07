resource "aws_route53_cidr_collection" "ip_based" {
  name = "girikgarg-ip-routing"
}

# CIDR location "India/APS1" - CIDR from AWS ap-south-1 prefix list
resource "aws_route53_cidr_location" "aps1" {
  cidr_collection_id = aws_route53_cidr_collection.ip_based.id
  name = "APS1"
  cidr_blocks = [for e in data.aws_ec2_managed_prefix_list.ap_south_1.entries : e.cidr]
}

# CIDR location "US West 2" - CIDR from AWS us-west-2 prefix list
resource "aws_route53_cidr_location" "usw2" {
  cidr_collection_id = aws_route53_cidr_collection.ip_based.id
  name = "USW2"
  cidr_blocks = [for e in data.aws_ec2_managed_prefix_list.us_west_2.entries : e.cidr]
}