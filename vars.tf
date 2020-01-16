variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "AMIS" {
  type = map(string)
  default = {
    eu-west-1 = "ami-0987ee37af7792903"
    eu-west-2 = "ami-05945867d79b7d926"
    eu-west-3 = "ami-00c60f4df93ff408e"
  }
}

