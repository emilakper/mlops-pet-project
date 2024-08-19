output "public_ip_db_address" {
  value = openstack_networking_floatingip_v2.floatingip_1.address
}

output "public_ip_air_address" {
  value = openstack_networking_floatingip_v2.floatingip_2.address
}