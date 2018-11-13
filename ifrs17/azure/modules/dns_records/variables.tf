variable "server" {
  description = "Defines the IP address of the DNS server."
  default     = "10.224.32.73"
}

variable "key_name" {
  description = "Defines the TSIG key name."
  default     = "terraform."
}

variable "key_algorithm" {
  description = "Define the algorithm to use. For TSIG default is hmac-md5"
  default     = "hmac-md5"
}

variable "key_secret" {
  description = "The secret for securing with TSIG."
  default     = ""
}

variable "zone" {
  description = "The zone this record belongs to."
  default     = "azure.atradiusnet.com."
}

variable "names" {
  type        = "list"
  description = "The hostname and aliases this record is provided for."
  default     = []
}

variable "cname" {
  description = "The CNAME of this host."
  default     = ""
}

variable "addresses" {
  type        = "list"
  description = "List of ip addresses this record will be pointing at."
  default     = []
}

variable "ttl" {
  description = "Time To Live"
  default     = 300
}
