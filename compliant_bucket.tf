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

# Compliant Security Group: Restricted inbound access (no SSH open to 0.0.0.0/0)
resource "aws_security_group" "compliant_sg" {
  name        = "app-production-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Environment = "Production"
    CostCenter  = "CC-8910"
  }
}
