data "aws_iam_policy_document" "build_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "build-role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json
}

resource "aws_iam_policy" "build-ecr" {
  name = "ECRPOLICY"
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
    ],
    "Version" : "2012-10-17"
  })
}

resource "aws_iam_policy" "eks-access" {
  name = "EKS-access"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
            ],
            "Resource": "*"
        }
    ]
} )
}
resource "aws_iam_role_policy_attachment" "eks" {
  role = aws_iam_role.build-role.name
  policy_arn = aws_iam_policy.eks-access.arn
}
resource "aws_iam_role_policy_attachment" "attachmentsss" {
  role = aws_iam_role.build-role.name
  policy_arn = aws_iam_policy.build-ecr.arn
}

data "aws_iam_policy_document" "build-policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterfacePermission"]
    resources = ["*"]

    

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "s3_access" {
  role   = aws_iam_role.build-role.name
  policy = data.aws_iam_policy_document.build-policy.json
}

resource "aws_ecr_repository" "prod-app-repository" {
  name                 = var.ecr_repository
  image_tag_mutability = var.tag_mutability


  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_codebuild_project" "python-api-codebuild" {
  name          = var.project_name
  build_timeout = "5" 
  service_role  = aws_iam_role.build-role.arn


  artifacts {
    type           = "S3"
    location       = aws_s3_bucket.codepipeline_bucket.bucket
    name           = var.bucket_pipeline
    namespace_type = "BUILD_ID"
  }

  environment {
    privileged_mode = true
    compute_type                = var.compute_type
    image                       = var.image_cb
    type                        = var.type_cb
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "IMAGE_TAG"
      value = var.tag_cb
    }
    environment_variable {
      name = "IMAGE_REPO_NAME"
      value = var.ecr_repository
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name = "AWS_ACCOUNT_ID"
      value = var.accountID
    }
    environment_variable {
      name = "CLUSTER_NAME"
      value = "${var.project_name}-${var.stage}-eks"
    }
    environment_variable {
      name = "GIT_NAME"
      value = "iriscafe"
    }
    environment_variable {
      name = "GIT_EMAIL"
      value = "irislisboa.c@gmail.com"
    }
    environment_variable {
      name = "GIT_TOKEN"
      value = file("${path.module}/gitToken.txt")
    }
  }
  
  source {
    type            = var.type_resource_cb
    location        = var.location_url
    git_clone_depth = 1
    buildspec       = var.path_buildspec
  }
}
