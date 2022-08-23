variable "key_pair_name" {
  default     = "your_private_key_name"
  description = "Private key name of animal for life"
}

variable "server_instance_type" {
  default     = "t2.micro"
  description = "Instance type"
}

variable "access_key" {
  default     = "your_own_access_key_ID"
  description = "IAM Access Key ID"
  sensitive   = true
}

variable "secret_key" {
  default   = "your_own_access_key_secret"
  sensitive = true
}

variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}
