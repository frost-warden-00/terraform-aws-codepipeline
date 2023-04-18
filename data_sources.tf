####################   Data AWS

data "aws_caller_identity" "account" {}

data "aws_availability_zones" "available" {}

data "aws_s3_bucket" "output_artifact" {
  bucket = var.bucket_name_artifact
}

data "aws_codecommit_repository" "project" {
  repository_name = var.repository_name
}

data "aws_s3_bucket" "codepipeline" {
  bucket = var.bucket_name_codepipeline
}

data "template_file" "codepipeline_environment_variables" {
  template = fileexists("templates/codepipeline/environment_variables.json") ? file("templates/codepipeline/environment_variables.json") : file("${path.module}/templates/codepipeline/environment_variables.json")
  vars = {
    account_id          = data.aws_caller_identity.account.account_id
    ecr_repository_name = var.repository_name
    ecr_repository_url  = "${data.aws_caller_identity.account.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}"
    env                 = var.env
  }
}