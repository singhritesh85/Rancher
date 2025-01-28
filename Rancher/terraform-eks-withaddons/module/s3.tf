#Creation of S3 Bucket
resource "aws_s3_bucket" "s3_bucket" {
###  count = var.s3_bucket_exists == false ? 1 : 0        ### create only one bucket 
  bucket = "s3bucketforlonghorn-${var.env}"

  force_destroy = true

  tags = {
    Environment = var.env
  }
}

#S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3bucket_encryption" {
###  count = var.s3_bucket_exists == false ? 1 : 0
###  bucket = aws_s3_bucket.s3_bucket[0].id
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
