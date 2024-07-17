resource "aws_eks_cluster" "eks_cluster" {
    name     = "my-eks-cluster"
    role_arn = aws_iam_role.eks_role.arn


vpc_config {
    subnet_ids        = aws_subnet.eks_subnet.*.id
    security_group_id = {aws_security_group.eks_cluster_sg.id}
}

depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}

resource "aws_iam_role" "eks_role" {
    name = "eks-role"

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

resource "aws_eks_node_group" "eks_node_group" {
    cluster_name = aws_eks_cluster.eks_cluster.name
    node_group_name = "my-eks-node-group"
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids = aws_subnet.eks_subnet.*.id

    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    instance_types = ["t3.medium"]
    
    depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy]
}

resource "aws_iam_role" "eks_node_role" {
    name = "eks-node-role"
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


resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks_node_role.name
}