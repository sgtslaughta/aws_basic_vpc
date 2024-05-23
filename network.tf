resource "aws_security_group" "ubuntu_sg" {
  description = "Security group for servers"
  name        = "dev_sg"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow SSH from user"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [
      "${var.MY_IP}/32"
    ]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}dev_sg"
    },
  )
}