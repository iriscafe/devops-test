variable "project_name"{
    type    = string
}

variable "stage" {
  type    = string
  default = "staging"
}

variable "ecr_repository"{
  type    = string
}

variable "tag_mutability"{
  type    = string
}

variable "bucket_pipeline"{
  type    = string
}

variable "compute_type" {
  type    = string
}

variable "image_cb" {
  type    = string
}

variable "type_cb" {
  type    = string
}

variable "tag_cb" {
  type    = string
}

variable "region" {
  type    = string
}

variable "accountID" {
  type    = string
}

variable "type_resource_cb" {
  type    = string
}

variable "location_url" {
  type    = string
}

variable "path_buildspec" {
  type    = string
}
