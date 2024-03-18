terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
  # Configuration options
region = "us-east-1"

}

variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "s3-no-security-items-enabled" {
  bucket = "s3-no-security-items-${var.bucket_name}"

  website {
      index_document = "index.htm"
      error_document = "error.html"

  }

  tags  = {
      Name = "s3-no-security-items"
      Environment = "Production"

  }

}     

resource "aws_s3_bucket_public_access_block" "s3-no-security-items-enabled" {
    bucket = aws_s3_bucket.s3-no-security-items-enabled.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false

} 

resource "aws_s3_bucket_ownership_controls" "s3-no-security-items-enabled" {
  bucket = aws_s3_bucket.s3-no-security-items.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}  

resource "aws_s3_bucket_acl" "s3-no-security-items-enabled" {
  depends_on = [  
  aws_s3_bucket_public_access_block.s3-no-security-items-enabled,
  aws_s3_bucket_ownership_controls.s3-no-security-items-enabled,

  ]
  bucket = aws_s3_bucket.s3-no-security-items-enabled.id
  acl = "public-read"
  
}
