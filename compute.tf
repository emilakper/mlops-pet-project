resource "selectel_vpc_keypair_v2" "keypair_1" {
  name       = "keypair"
  public_key = file("~/.ssh/id_rsa.pub")
  user_id    = selectel_iam_serviceuser_v1.serviceuser_1.id
}

resource "openstack_compute_flavor_v2" "flavor_1" {
  name      = "custom-flavor-with-network-volume"
  vcpus     = 2
  ram       = 2048
  disk      = 0
  is_public = false
  gpu       = 2

  lifecycle {
    create_before_destroy = true
  }
}

data "openstack_images_image_v2" "image_1" {
  name        = "Ubuntu 22.04 LTS Machine Learning 64-bit"
  most_recent = true
  visibility  = "public"
}

resource "openstack_compute_flavor_v2" "flavor_1" {
  name      = "custom-flavor-with-network-volume"
  vcpus     = var.vcpus
  ram       = var.ram
  disk      = 0
  is_public = false
  gpu       = var.gpu

  lifecycle {
    create_before_destroy = true
  }
}

resource "openstack_blockstorage_volume_v3" "volume_1" {
  name                 = "boot-volume-for-server"
  size                 = var.disk_size
  image_id             = data.openstack_images_image_v2.image_1.id
  volume_type          = "fast.ru-7a"
  availability_zone    = "ru-7a"
  enable_online_resize = true

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = "external-network"
}

resource "openstack_networking_floatingip_associate_v2" "association_1" {
  port_id     = openstack_networking_port_v2.port_1.id
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
}