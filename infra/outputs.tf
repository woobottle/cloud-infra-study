output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public Subnet ID 목록"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private Subnet ID 목록"
  value       = aws_subnet.private[*].id
}

output "cluster_name" {
  description = "EKS 클러스터 이름"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS 클러스터 API 엔드포인트"
  value       = aws_eks_cluster.main.endpoint
}

output "ecr_repository_url" {
  description = "ECR 레포지토리 URL"
  value       = aws_ecr_repository.next_app.repository_url
}

output "kubeconfig_command" {
  description = "kubeconfig 설정 명령어"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.aws_region}"
}
