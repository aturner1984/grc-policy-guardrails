# Fails GRC checks: Missing Server-Side Encryption and required CostCenter tag
resource "aws_s3_bucket" "data_dump_insecure" {
  bucket = "temp-data-dump-bucket-unsecure"

  tags = {
    Environment = "Dev"
  }
}
