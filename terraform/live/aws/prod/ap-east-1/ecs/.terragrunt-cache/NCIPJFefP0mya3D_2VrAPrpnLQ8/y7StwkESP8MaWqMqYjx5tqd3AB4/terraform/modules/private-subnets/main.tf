resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  lifecycle {
    precondition {
      condition     = length(var.availability_zones) == length(var.private_subnet_cidrs)
      error_message = "availability_zones and private_subnet_cidrs must have the same length."
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private"
    Tier = "private"
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-${count.index + 1}"
    Tier = "private"
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
