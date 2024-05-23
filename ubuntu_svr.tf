
# Define the variables
data "aws_ami" "amazon_linux_ec2_ami" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }

  owners = [
    "099720109477"
  ]
}

variable "instance_type" {
  default = "t2.micro" # Change to your desired instance type
}

variable "MY_IP" {
  description = "User IP"
  type        = string
  sensitive   = true
}

# Create a new Ubuntu VM instance
resource "aws_instance" "ubuntu_vm" {
  ami           = data.aws_ami.amazon_linux_ec2_ami.id
  instance_type = var.instance_type
  subnet_id     = concat(aws_subnet.dev_public_subnet[*].id, aws_subnet.dev_private_subnet[*].id)
  key_name      = "csd_com"
  vpc_security_group_ids = [
    aws_security_group.ubuntu_sg.id
  ]

  tags = {
    Name = "UbuntuVM"
  }
}

resource "aws_eip" "ubuntu_vm" {
  instance = aws_instance.ubuntu_vm.id

  tags = merge(
    var.additional_tags, {
      Name = "ubuntu_vm"
    },
  )
}