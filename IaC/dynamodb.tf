resource "aws_dynamodb_table" "product" {
 name = "official_record_tf"
 billing_mode = "PROVISIONED"
 read_capacity= "30"
 write_capacity= "30"
 attribute {
  name = "id"
  type = "N"
 }
 hash_key = "id"
}
