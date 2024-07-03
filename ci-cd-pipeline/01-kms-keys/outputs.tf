output "arn" {
  value       = aws_kms_key.encryption_kms_key.arn
  description = "The ARN of the KMS key"
}
