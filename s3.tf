resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  depends_on = [ aws_api_gateway_stage.prod ]
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add this new resource to grant CloudFront access via OAC
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "web_app/index.html"
  content_type = "text/html"
  etag         = filemd5("web_app/index.html")
}

# resource "aws_s3_object" "script" {
#   bucket       = aws_s3_bucket.website_bucket.id
#   key          = "script.js"
#   source       = "web_app/script.js"
#   # content_type = "application/javascript"
#   # Use templatefile to inject the API Gateway URL
#   content = templatefile("${path.module}/template/script.js.tpl", {
#     invoke_url = aws_api_gateway_stage.prod.invoke_url
#   })
#   etag         = filemd5("web_app/script.js")
# }

resource "aws_s3_object" "script" {
  bucket  = aws_s3_bucket.website_bucket.id
  key     = "script.js"
  # source is correctly commented out when using content

  # Use templatefile to inject the API Gateway URL
  content = templatefile("${path.module}/template/script.js.tpl", {
    invoke_url = aws_api_gateway_stage.prod.invoke_url
  })

  # CORRECT ETAG: Calculate the hash of the final content
  etag = md5(templatefile("${path.module}/template/script.js.tpl", {
    invoke_url = aws_api_gateway_stage.prod.invoke_url
  }))
}

resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "style.css"
  source       = "web_app/style.css"
  content_type = "text/css"
  etag         = filemd5("web_app/style.css")
}


