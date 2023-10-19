# aws_region

variable "aws_region" {
  description = "Varginia_region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of VPC tp pass to Security Group"
  type        = string
  default     = "null"
}


variable "availability_zones" {
  description = "A list of AWS availability zones where you want to deploy resources."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "company_name" {
  description = "company name"
  type        = string
}

# tags


#vpc_CIDR_block

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.31.0.0/16"
}

#Public_subnet_CIDR

variable "pub_sub_cidr_block" {
  description = "public subnet1 CIDR block for the VPC"
  type        = list(string)
  default     = ["172.31.0.0/20", "172.31.16.0/20"]
}

variable "pvt_sub1_cidr_block" {
  description = "private sub1 CIDR block for the VPC"
  type        = string
  default     = "172.31.32.0/20"
}
