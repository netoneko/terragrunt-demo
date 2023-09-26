variable "helm_repo_path" {
  type = string
}

variable "helm_chart_name" {
  type = string
}

variable "helm_release_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "values" {
  type = list(string)
  default = []
}
