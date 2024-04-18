variable "cidr_ip" {
  type    = string
  default = "10.10.0.0"
}

variable "ips_subnets" {
  type    = list(string)
  default = ["10.10.30.0", "10.10.40.0", "10.10.20.0", "10.10.10.0"]
}

variable "project_name" {
  type = string
}
