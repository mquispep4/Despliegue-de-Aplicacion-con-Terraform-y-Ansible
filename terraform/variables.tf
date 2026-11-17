
variable "aws_region" {
  description = "Region donde se creara la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nombre del par de claves SSH existente en AWS"
  type        = string
}

variable "ssh_cidr" {
  description = "IP autorizada para conexiones SSH"
  type        = string
}

variable "app_port" {
  description = "Puerto de la aplicacion Spring Boot"
  type        = number
  default     = 8080
}
