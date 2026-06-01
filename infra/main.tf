resource "yandex_vpc_network" "kittygram" {
  name = "${var.project_name}-network"
}

resource "yandex_vpc_subnet" "kittygram" {
  name           = "${var.project_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.kittygram.id
  v4_cidr_blocks = var.subnet_cidr
}

resource "yandex_vpc_security_group" "kittygram" {
  name        = "${var.project_name}-security-group"
  description = "Allow SSH and Kittygram gateway traffic only."
  network_id  = yandex_vpc_network.kittygram.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description    = "Kittygram gateway"
    protocol       = "TCP"
    port           = var.gateway_port
    v4_cidr_blocks = var.gateway_allowed_cidrs
  }

  egress {
    description    = "All outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_compute_instance" "kittygram" {
  name        = var.vm_name
  hostname    = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.disk_size_gb
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.kittygram.id
    security_group_ids = [yandex_vpc_security_group.kittygram.id]
    nat                = true
  }

  metadata = {
    ssh-keys  = "${var.vm_user}:${var.ssh_public_key}"
    user-data = templatefile("${path.module}/cloud-init.yml", { vm_user = var.vm_user })
  }
}
