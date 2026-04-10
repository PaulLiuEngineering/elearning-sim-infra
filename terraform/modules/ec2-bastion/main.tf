data "aws_ssm_parameter" "ssh_allowlist" {
  for_each = toset(var.allowed_cidr_block_ssm_parameter_names)

  name            = each.value
  with_decryption = false
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  effective_ssh_allowlist_cidrs = sort(distinct(compact([for parameter in data.aws_ssm_parameter.ssh_allowlist : trimspace(parameter.value)])))
}

resource "aws_security_group" "bastion" {
  name        = "${var.name_prefix}-bastion"
  description = "Security group for the ${var.name_prefix} bastion host"
  vpc_id      = var.vpc_id

  lifecycle {
    precondition {
      condition     = length(local.effective_ssh_allowlist_cidrs) > 0
      error_message = "Provide at least one SSM parameter name for bastion SSH access."
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(local.effective_ssh_allowlist_cidrs)

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  description       = "Allow SSH from approved CIDRs"
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion"
  })
}
