terraform {
  backend "s3" {
   bucket         = "dolo-dempo"
   key            = "state/downstream-eks-1/terraform.tfstate"
   region         = "us-east-2"
   encrypt        = true
   dynamodb_table = "terraform-state"
 }
}
