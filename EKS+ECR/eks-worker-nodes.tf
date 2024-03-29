#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "node-role" {
  name = "terraform-eks-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "node-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "node-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-role.name
}

resource "aws_eks_node_group" "eks-ng" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node-group-name
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = aws_subnet.eks-subnet[*].id
  instance_types  = [var.instance_types]

  scaling_config {
    desired_size = var.scaling-desired
    max_size     = var.scaling-max
    min_size     = var.scaling-min
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
