resource "aws_cloudwatch_log_group" "LogGroup" {
  name = "/${var.project_name}_${var.stage}-loggroup"

  tags = {
    Name        = "${var.project_name}-LogGroup"
    Environment = "clustereks"
  }
}

resource "aws_eks_node_group" "EKSNodeGroup" {
  cluster_name    = "${var.project_name}-${var.stage}-eks"
  node_group_name = "${var.project_name}_${var.stage}_NodeGroup"
  ami_type        = var.AmiTypeInstance
  instance_types  = [var.InstanceTypes[0]]
  node_role_arn   = aws_iam_role.NodeInstanceRole.arn
  subnet_ids      = slice(var.network.subnets, length(var.network.subnets) - 2, length(var.network.subnets))

  scaling_config {
    desired_size = 1
    max_size     = var.scaling_config["default_config"].max_size
    min_size     = var.scaling_config["default_config"].min_size
  }

  depends_on = [aws_eks_cluster.EKSCluster]

  tags = {
    Name        = "${var.project_name}-EKSNodeGroup"
    Environment = "clustereks"
  }
}

resource "aws_ssm_parameter" "SsmNodeRole" {
  name  = "/${var.project_name}/${var.stage}/NODES/ROLE_ARN"
  type  = "String"
  value = aws_iam_role.NodeInstanceRole.arn
}