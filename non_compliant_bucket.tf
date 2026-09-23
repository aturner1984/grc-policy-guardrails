# Fails GRC checks: Missing Server-Side Encryption and required CostCenter tag
resource "aws_s3_bucket" "data_dump_insecure" {
  bucket = "temp-data-dump-bucket-unsecure"

  tags = {
    Environment = "Dev"
  }
}

# Non-Compliant Security Group: Dangerous SSH port 22 open to the entire internet
resource "aws_security_group" "insecure_sg" {
  name        = "open-ssh-sg-dev"
  description = "Insecure SG open to internet"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "Dev"
  }
}
