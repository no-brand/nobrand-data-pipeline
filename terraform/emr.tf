resource "aws_s3_bucket" "s3_bucket_emr" {
  bucket = "${var.project}_emr"
}
