resource "selectel_vpc_keypair_v2" "keypair_1" {
  name       = "keypair"
  public_key = file("~/.ssh/id_rsa.pub")
  user_id    = selectel_iam_serviceuser_v1.serviceuser_1.id
}

data "openstack_images_image_v2" "image_1" {
  name        = "Ubuntu 20.04 LTS 64-bit"
  most_recent = true
  visibility  = "public"
  depends_on = [
    selectel_vpc_project_v2.project_1
  ]
}

resource "openstack_compute_instance_v2" "db_1" {
  name            = "db_1"
  flavor_id       = "3021"
  key_pair        = selectel_vpc_keypair_v2.keypair_1.name
  security_groups = ["default"]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_1.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.port_1.id
  }

  lifecycle {
    ignore_changes = [image_id]
  }

  vendor_options {
    ignore_resize_confirmation = true
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