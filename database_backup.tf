# Non-compliant: Missing CostCenter tag and server-side encryption
resource "aws_s3_bucket" "db_backups_temp" {
  bucket = "prod-database-backups-unencrypted-001"

  tags = {
    Environment = "Production"
    Owner       = "DBATeam"
  }
}
