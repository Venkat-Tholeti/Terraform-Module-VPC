resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
  
  peer_vpc_id   = data.aws_vpc.default.id #accepter vpc which is default VPC in our case
  vpc_id        = aws_vpc.main.id # Requestor VPC

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  auto_accept = true

  tags = merge(
    var.vpc_peering_tags,
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-default"
    }
  )
}