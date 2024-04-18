variable "project_name" {
  type = string
}

variable "AmiTypeInstance" {
  type    = string
  default = "AL2_x86_64"
} 

variable "InstanceTypes" {
  type    = list(string)
  default = ["t3.medium"] 
} 

variable "stage" {
  type    = string
  default = "staging"
}

variable "network" {
  type = object({
    vpc_id  = string
    subnets = list(string)
  })
}
variable "scaling_config" {
  type = map(object({
    desired_size = number
    max_size     = number
    min_size     = number
  }))
  
  default = {
    "default_config" = {
      desired_size = 1
      max_size     = 2
      min_size     = 1
    }
  }
}