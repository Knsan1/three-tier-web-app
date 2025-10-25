resource "aws_dynamodb_table" "user_data" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userId"

  attribute {
    name = "userId"
    type = "S"
  }
}

# # 3. Add the "Mercedes" item
# # This resource creates the first item in the table.
# resource "aws_dynamodb_table_item" "mercedes" {
#   table_name = aws_dynamodb_table.user_data.name
#   hash_key   = aws_dynamodb_table.user_data.hash_key

#   # The 'item' attribute uses jsonencode to create the required DynamoDB JSON format.
#   # Each attribute value is an object specifying its type (e.g., "S" for String, "N" for Number).
#   item = jsonencode({
#     userId    = { "S" = "1" },
#     brand = { "S" = "Mercedes" },
#     model = { "S" = "G-Class" },
#     name  = { "S" = "Mercedes-Benz" },
#     year  = { "N" = "2024" } # "N" for Number, but the value is still passed as a string
#   })
# }

# # 4. Add the "Toyota" item
# # This second resource creates the Toyota item in the same table.
# resource "aws_dynamodb_table_item" "toyota" {
#   table_name = aws_dynamodb_table.user_data.name
#   hash_key   = aws_dynamodb_table.user_data.hash_key

#   item = jsonencode({
#     userId    = { "S" = "2" },
#     brand = { "S" = "Toyota" },
#     model = { "S" = "Land Cruiser" },
#     name  = { "S" = "Toyota Motor Corp" },
#     year  = { "N" = "2024" }
#   })
# }
