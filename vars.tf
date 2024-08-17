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

variable "vcpus" {
  description = "Number of vCPUs"
  type        = number
  default     = 2
}

variable "ram" {
  description = "Amount of RAM in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 5
}

variable "gpu" {
  description = "Number of GPUs"
  type        = number
  default     = 0
}