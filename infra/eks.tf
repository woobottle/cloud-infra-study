resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "main" {
  name = var.cluster_name
  version = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = concat(
      aws_subnet.public[*].id,
      aws_subnet.private[*].id
    )
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_iam_role" "eks_node" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-nodes"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = aws_subnet.private[*].id

  capacity_type  = var.use_spot_instances ? "SPOT" : "ON_DEMAND"
  instance_types = var.node_instance_types

  scaling_config {
    desired_size = var.node_desired_count
    min_size     = var.node_min_count
    max_size     = var.node_max_count
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]
}


# - eks.tf를 읽고, 워커 노드가 어떤 Subnet에 배치되는지 찾아보세요. (Public? Private?) -> private => 모든걸 control plane에서 제어해야 한다/ control plane에서 트래픽을 관리해주는 느낌
# - pod들은 public IP에 존재하면 안된다 / pod는 보통 10개 11개가 뜬다 / 1개 pod는 1개 컨테이너로 구성
# - IAM Role이 2개 존재합니다 (클러스터용, 노드용). 각각 어떤 권한을 가지고 있고, 왜 분리되어 있는지 파악하세요.
# ==> 클러스터용: EKS 클러스터를 생성하고 관리하는 데 필요한 권한 / 아파트 단지 전체의 느낌
# ==> 노드용: EKS 클러스터의 워커 노드를 생성하고 관리하는 데 필요한 권한 / 아파트 동의 느낌
# ==> 분리된 이유: 둘의 역할이 다르기 때문에 클러스터와 워커 노드의 권한을 분리합니다. 
# ==> 클러스터는 관리용이므로 더 넓은 권한을 가지고, 워커 노드는 실제 컨테이너를 실행하는 역할만 하므로 최소한의 권한만 가진다.

# - variables.tf를 확인하고, node_instance_type이나 node_count 같은 값을 바꿀 수 있다는 것을 이해하세요.

# Pod란 = 컨테이너를 실행하는 단위 / 1개 이상의 컨테이너로 구성
# 컨테이너란 = 애플리케이션을 실행하는 단위
# 애플리케이션이란 = 내가 만든 앱

# 서비스가 pod보다 더 상위 개념
# 쿠버네티스에서 모든 노출 되는 곳은 서비스이다 / 서비스 안에 pod가 있는 것이다
# 서비스는 꼭 1개의 pod로 구성되지는 않는다 / pod 집합 / 서비스의 최소 단위 이다
