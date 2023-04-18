##################  Variables  ##################

variable "region" {
  type        = string
  description = "Name of Region where well be working"
}

variable "project" {
  type        = string
  description = "Name of the project to deploy"
}

variable "env" {
  type        = string
  description = "Name of the environment"
}

variable "repository_name" {
  type        = string
  description = "Name of repository project"
}

variable "branch_name" {
  type        = string
  description = "Name of Branch"
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
      type  = string
  }))

  default     = []
  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS Cluster"
}

variable "service_name" {
  type        = string
  description = "Name of the Service Name"
}

variable "file_name" {
  type        = string
  description = "Name of the file name for the image definition document"
  default     = "imagedefinitions.json"
}

variable "bucket_name_artifact" {
  type        = string
  description = ""
}

variable "bucket_name_codepipeline" {
  type        = string
  description = ""
}