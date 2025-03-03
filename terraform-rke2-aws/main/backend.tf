terraform {
 backend "s3" {
   bucket         = "dolo-dempo"
   key            = "state/rke2/terraform.tfstate"
   region         = "us-east-2"
   encrypt        = true
   dynamodb_table = "terraform-state"
 }
}
