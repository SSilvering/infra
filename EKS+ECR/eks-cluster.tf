#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#  * ECR repo for k8s cluster
#

resource "aws_iam_role" "cluster-role" {
  name = "terraform-eks-${var.cluster-name}-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role_policy_attachment" "cluster-role-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_security_group" "cluster-sg" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks"
  }
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster-sg.id]
    subnet_ids         = aws_subnet.eks-subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-role-AmazonEKSVPCResourceController,
  ]
}

resource "aws_ecr_repository" "ecr-repo" {
  name                 = var.ecr-repo-name
  image_tag_mutability = var.ecr-tag-mutability

  image_scanning_configuration {
    scan_on_push = var.scan-on-push
  }
}

# Return external ip of current workstation
data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}
