resource "aws_s3_bucket" "audit_logs_compliant" {
  bucket = "company-audit-logs-prod-001"

  tags = {
    Environment = "Production"
    Owner       = "ComplianceTeam"
    CostCenter  = "CC-8910"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "compliant_enc" {
  bucket = aws_s3_bucket.audit_logs_compliant.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
