# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# Define the variables
variable "ami" {
  default = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 LTS AMI ID, you can change it if needed
}

variable "instance_type" {
  default = "t2.micro" # Change to your desired instance type
}

variable "key_name" {
  default = "csd_com" # Change to your key pair name
}

# Create a new Ubuntu VM instance
resource "aws_instance" "ubuntu_vm" {
  ami           = var.ami
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
