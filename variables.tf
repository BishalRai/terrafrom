variable "do_token" {
  description = "DigitalOcean personal access token"
  type        = string
  sensitive   = true   # won't be printed in logs
}

variable "ssh_fingerprint" {
  description = "MD5 fingerprint of your SSH public key (from DO dashboard)"
  type        = string
}
