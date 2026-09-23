resource "aws_s3_bucket" "db_backups_temp" {
  bucket = "prod-database-backups-unencrypted-001"

  tags = {
    Environment = "Production"
    Owner       = "DBATeam"
    CostCenter  = "CC-9900"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "db_backups_enc" {
  bucket = aws_s3_bucket.db_backups_temp.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
