
# Creates a secure S3 bucket to store the Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-tfstate"

  # Prevent accidental deletion of the state file bucket
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "${var.project_name}-tfstate-bucket"
  }
}

# Enable versioning to keep a history of your state files
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for security
resource "aws_s3_bucket_server_side_encryption_configuration" "state_sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the state file bucket
resource "aws_s3_bucket_public_access_block" "state_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the bucket name to be used in the main configuration
output "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state."
  value       = aws_s3_bucket.terraform_state.bucket
}