resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "pipeline-bucket-iris"
  force_destroy = true
}
