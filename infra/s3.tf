resource "aws_s3_bucket" "raw_data_source" {
  bucket = "raw-data-source"

  tags = {
    Name = "source"
  }
}
