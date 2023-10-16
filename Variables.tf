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
  default     = "thara_data"
}

# tags

variable "tharav_data" {
  description = "Tags that will be applied to the aws resource"
}

#vpc_CIDR_block

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.31.0.0/16" 
}

#Public_subnet_CIDR

variable "pub-sub_cidr_block" {
  description = "public subnet1 CIDR block for the VPC"
  type        = string
  default     = ["172.31.1.0/20", "172.31.2.0/20"]
}

variable "pvt-sub1_cidr_block" {
  description = "private sub1 CIDR block for the VPC"
  type        = string
  default     = "172.31.100.0/20" 
}
