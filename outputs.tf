output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "api_gateway_invoke_url" {
  description = "The invoke URL for the API Gateway"
  value       = aws_api_gateway_deployment.api.invoke_url
}
