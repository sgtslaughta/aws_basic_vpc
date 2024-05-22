
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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCi1FNt4NMX5w/s/KhDFVSEPsWrPLivQuvMp64Ze5ycmEEHcl6jrmwpvAROQSSefZhDPOm+EyOWHwvv/+oPBJm8YmKWXUtwbFNdXYbq5a+8syvmxbsQfHdUdNMhlWbc1logxFbUL0EiDJ+krJIub8KlIGTULbvpo8DsKHNJ0LhyJ3U3fZaKR/vGZM6IpvhJCqORnH2aa7M1qnoOj59U3jSjEVWItjLIF5FyzWpLUS67QseHwPK7IGjw6Z/AGcilFuF0O/gCOoGPEWSxy0+jFqJxEGDOFLTjk91D30bp6wS4esbfQHGpSrJSwKlZUe32J48PLtp4El6PxIPZJDzq5o/S+3jOTJ5ATeSfj3/Gaf9fT3EbO7+MHpRrOzpf9HEah0FlVCCBKxmANqzgT0UIogNbvxNwpXVqsFR6FUkBFEytA8EhQhpnmSrlCj+vDlxxszfS50PrZ1K345M9IvGvhnOxIXco/nc7/xhQ6e7zBnT+2Y4tavcOrt03E5N+hJ/DeSU= user@ubu-dev-ws"
}

# Create a new Ubuntu VM instance
resource "aws_instance" "ubuntu_vm" {
  ami           = data.aws_ami.amazon_linux_ec2_ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
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
