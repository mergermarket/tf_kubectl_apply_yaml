variable "yaml" {
  type        = "string"
  description = "the yaml to load"
}

variable "yaml_filename" {
  type        = "string"
  description = "name of file to use to store yaml"
  default     = "the.yaml"
}

variable "cluster_name" {
  type        = "string"
  description = "name of the jenkins eks cluster"
  default     = "jenkins-eks"
}
