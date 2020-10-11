resource "random_string" "ec2" {
  length  = 8
  special = false
}

resource "aws_security_group" "ec2" {
  name        = "${terraform.workspace}_ec2_security_group_${random_string.ec2.result}"
  vpc_id      = aws_vpc.vpc.id
  description = "${terraform.workspace} EC2 security group"
  tags        = { Name = "${terraform.workspace} ec2 security group" }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Hackers might take advantage of this rule... :D"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  for_each                    = local.subnets
  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = each.value.map_public_ip_on_launch
  availability_zone           = each.value.availability_zone
  instance_type               = var.instance_type
  monitoring                  = false
  subnet_id                   = aws_subnet.subnets[each.key].id
  tags                        = { Name = "${terraform.workspace}-web-${each.key}" }
  user_data                   = file("${path.module}/user_data.sh")
  vpc_security_group_ids      = [aws_security_group.ec2.id]

  lifecycle {
    create_before_destroy = "true"
    ignore_changes        = [tags]
  }
}
