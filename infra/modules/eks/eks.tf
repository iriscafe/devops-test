resource "aws_security_group" "ControlPlaneSG" {
  name        = "${var.project_name}_${var.stage}_ControlPlaneSG"
  description = "Enables access to all VPC protocols and IPs"
  vpc_id      = var.network.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  tags = {
    Name        = "${var.project_name}-ControlPlaneSG"
    Environment = "clusterks"
  }
}

resource "aws_eks_cluster" "EKSCluster" {
  name       = "${var.project_name}-${var.stage}-eks"
  role_arn   = aws_iam_role.EKSServiceRole.arn
  

  vpc_config {
    security_group_ids = [aws_security_group.ControlPlaneSG.id]
    subnet_ids = slice(var.network.subnets, 0, 2)
  }

  version = "1.28"

  tags = {
    Name        = "${var.project_name}-eks"
    Environment = "clustereks"
  }
}

resource "aws_ssm_parameter" "SsmEksName" {
  name  = "/${var.project_name}/EKS_NAME"
  value = "${var.project_name}-${var.stage}-eks"
  type  = "String"
}