
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

variable "key_name" {
  default = "csd_com" # Change to your key pair name
}

# Create a new Ubuntu VM instance
resource "aws_instance" "ubuntu_vm" {
  ami           = data.aws_ami.amazon_linux_ec2_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
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


output "dev_openvpn_public_ip" {
  description = "Public IP address of the OpenVPN server"
  value       = aws_eip.ubuntu_vm.public_ip
  depends_on = [
    aws_eip.ubuntu_vm
  ]
}

output "dev_openvpn_public_dns" {
  description = "Public DNS address of the OpenVPN server"
  value       = aws_eip.ubuntu_vm.public_dns
  depends_on = [
    aws_eip.ubuntu_vm
  ]
}
