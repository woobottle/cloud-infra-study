############################
# General
############################

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름 (리소스 네이밍에 사용)"
  type        = string
  default     = "cloud-infra-lab"
}

############################
# VPC / Network
############################

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR 목록 (AZ별 1개)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR 목록 (AZ별 1개)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "사용할 AZ 목록"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

############################
# EKS
############################

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "cloud-infra-lab"
}

variable "kubernetes_version" {
  description = "Kubernetes 버전"
  type        = string
  default     = "1.30"
}

variable "node_instance_types" {
  description = "워커 노드 인스턴스 타입"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_count" {
  description = "워커 노드 Desired 수"
  type        = number
  default     = 3
}

variable "node_min_count" {
  description = "워커 노드 최소 수"
  type        = number
  default     = 2
}

variable "node_max_count" {
  description = "워커 노드 최대 수"
  type        = number
  default     = 4
}

variable "use_spot_instances" {
  description = "Spot Instance 사용 여부 (비용 절감)"
  type        = bool
  default     = true
}
