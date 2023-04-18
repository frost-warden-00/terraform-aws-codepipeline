resource "aws_codepipeline" "codepipeline" {
  name     = "${local.prefix}pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = data.aws_s3_bucket.output_artifact.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        BranchName           = var.branch_name
        RepositoryName       = var.repository_name
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${local.prefix}codebuild"
        #"EnvironmentVariables" = var.environment_variables#data.template_file.codepipeline_environment_variables.rendered
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      category        = "Deploy"
      name            = "Deploy-ECS"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      region          = var.region
      input_artifacts = ["build_output"]
      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
        FileName    = var.file_name
      }
    }
  }
}