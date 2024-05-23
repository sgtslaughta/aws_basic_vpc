output "dev_openvpn_public_ip" {
  description = "Public IP address of the server"
  value       = aws_eip.ubuntu_vm.public_ip
  depends_on = [
    aws_eip.ubuntu_vm
  ]
}

output "dev_openvpn_public_dns" {
  description = "Public DNS address of the server"
  value       = aws_eip.ubuntu_vm.public_dns
  depends_on = [
    aws_eip.ubuntu_vm
  ]
}