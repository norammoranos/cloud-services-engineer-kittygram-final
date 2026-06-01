variable "cloud_id" {
  description = "Yandex Cloud ID."
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID."
  type        = string
}

variable "zone" {
  description = "Yandex Cloud availability zone."
  type        = string
  default     = "ru-central1-a"
}

variable "project_name" {
  description = "Prefix for Kittygram infrastructure resources."
  type        = string
  default     = "kittygram"
}

variable "subnet_cidr" {
  description = "IPv4 CIDR block for the Kittygram subnet."
  type        = list(string)
  default     = ["10.10.0.0/24"]
}

variable "ssh_allowed_cidrs" {
  description = "IPv4 CIDR blocks allowed to connect to SSH."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "gateway_allowed_cidrs" {
  description = "IPv4 CIDR blocks allowed to connect to the Kittygram gateway."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "gateway_port" {
  description = "Public TCP port for the Kittygram gateway."
  type        = number
  default     = 9000

  validation {
    condition     = var.gateway_port > 0 && var.gateway_port <= 65535
    error_message = "gateway_port must be a valid TCP port."
  }
}

variable "vm_name" {
  description = "Compute instance name."
  type        = string
  default     = "kittygram-vm"
}

variable "vm_user" {
  description = "Linux user created by the cloud image metadata."
  type        = string
  default     = "yc-user"
}

variable "ssh_public_key" {
  description = "Public SSH key allowed to access the VM."
  type        = string
  sensitive   = true

  validation {
    condition     = length(trimspace(var.ssh_public_key)) > 0
    error_message = "ssh_public_key must not be empty."
  }
}

variable "image_family" {
  description = "Yandex Cloud image family for the VM boot disk."
  type        = string
  default     = "ubuntu-2404-lts"
}

variable "platform_id" {
  description = "Yandex Compute platform ID."
  type        = string
  default     = "standard-v1"
}

variable "vm_cores" {
  description = "Number of vCPUs for the VM."
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory size in GB for the VM."
  type        = number
  default     = 2
}

variable "vm_core_fraction" {
  description = "Guaranteed vCPU performance fraction."
  type        = number
  default     = 20
}

variable "disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 20
}
