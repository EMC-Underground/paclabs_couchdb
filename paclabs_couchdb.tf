# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = "administrator@pac.lab"
  password       = "Password#1"
  vsphere_server = "10.4.44.11"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

# Create a folder
resource "vsphere_folder" "frontend" {
  datacenter = "Datacenter"
  path = "support_services"
}

# Create a virtual machine within the folder
resource "vsphere_virtual_machine" "couchdb" {
  name   = "couchdb"
  datacenter = "Datacenter"
  domain = "couchdb.pac.lab"
  dns_servers = ["10.253.140.73"]
  cluster = "cluster"

  folder = "${vsphere_folder.frontend.path}"
  vcpu   = 2
  memory = 2048

  network_interface {
    label = "VM Network"
    ipv4_address = "10.4.44.13"
    ipv4_prefix_length = "24"
    ipv4_gateway = "10.4.44.1"
  }

  disk {
    datastore = "datastore1"
    template = "UbuntuTmpl"
    type = "thin"
  }

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
  }
  provisioner "file" {
    source = "docker-compose.yml"
    destination = "/tmp/docker-compose.yml"
    
    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
}
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "echo password | sudo -S /tmp/script.sh"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      password = "Password#1"
    }
  }
}
