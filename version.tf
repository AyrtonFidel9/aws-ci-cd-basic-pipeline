provider "aws" {
  profile                   = "kloud"
  shared_credentials_files  = ["~/.aws/credentials"]
  region                    = "us-east-1"
}