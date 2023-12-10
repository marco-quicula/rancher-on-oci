## SSH KEYS to Instances
resource "local_file" "ssh_private_key" {
  content         = file("instance_key")
  filename        = "id_rsa"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content         = file("instance_key.pub")
  filename        = "id_rsa.pub"
  file_permission = "0600"
}

locals {
  authorized_keys = [chomp(local_file.ssh_public_key.content)]
}