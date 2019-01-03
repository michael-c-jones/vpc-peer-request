

locals {
  this_pcx  = "${aws_vpc_peering_connection.this.id}"
  peer_cidr = "${var.peer_env["cidr"]}"
}


resource "aws_vpc_peering_connection" "this" {
  vpc_id      = "${var.this_env["vpc"]}"
  peer_vpc_id = "${var.peer_env["vpc"]}"
  peer_region = "${var.peer_env["region"]}"

  # can only do this within the same account
  auto_accept = "${var.auto_accept}"

  tags {
    Name           = "${var.this_env["full_name"]}-TO-${var.peer_env["full_name"]}"
    this_vpc       = "${var.this_env["full_name"]}"
    peer_vpc       = "${var.peer_env["full_name"]}"
    provisioned_by = "terraform"
  }
}

resource "aws_route" "pub_gateway" {
  route_table_id            = "${var.pub_route_table}"
  vpc_peering_connection_id = "${local.this_pcx}"
  destination_cidr_block    = "${local.peer_cidr}"
}

resource "aws_route" "priv_gateways" {
  count = "${length(var.priv_route_tables)}"

  route_table_id            = "${element(var.priv_route_tables, count.index)}"
  vpc_peering_connection_id = "${local.this_pcx}"
  destination_cidr_block    = "${local.peer_cidr}"
}



