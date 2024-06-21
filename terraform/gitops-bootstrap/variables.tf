variable "project_id" {
  description = "project_id"
  type    = string
  default = "civic-radio-424313-m2"
}

variable "region" {
  description = "region"
  type    = string
  default = "us-west1"
}

variable "client_id" {
  description = "client_id of azure keyvault"
  type    = string
  default = ""
}

variable "client_secret" {
  description = "client_secret of azure keyvault"
  type    = string
  default = ""
}