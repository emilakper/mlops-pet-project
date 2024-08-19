variable "selectel_domain_name" {
  description = "Selectel domain name"
  type        = string
}

variable "selectel_username" {
  description = "Selectel username"
  type        = string
}

variable "selectel_password" {
  description = "Selectel password"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "service_username" {
  description = "Service username"
  type        = string
}

variable "password" {
  description = "Service user password"
  type        = string
}

variable "db_disk_size" {
  description = "Size of the disk in GB for db_1"
  type        = number
  default     = 5
}

variable "air_disk_size" {
  description = "Size of the disk in GB for air_1"
  type        = number
  default     = 5
}

variable "db_flavor_id" {
  description = "Flavor ID for db_1"
  type        = string
  default     = "3021"
}

variable "air_flavor_id" {
  description = "Flavor ID for air_1"
  type        = string
  default     = "1015"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "192.168.199.0/24"
}