resource "aws_iam_policy" "ecr_read_only" {
  name        = "pull_image_policy"
  description = "Policy for pull image from ECR"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : [
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeImageReplicationStatus",
          "ecr:ListTagsForResource",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:GetLifecyclePolicy"
        ],
        Resource : "arn:aws:ecr:eu-central-1:*:repository/${var.project_name}-application"
      },
      {
        Sid : "VisualEditor1",
        Effect : "Allow",
        Action : [
          "ecr:GetRegistryPolicy",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:GetAuthorizationToken",
          "ecr:GetRegistryScanningConfiguration"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_main" {
  name = "Role_for_crud_servers"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "crud_server_profile_for_${var.project_name}_app"
  role = aws_iam_role.ec2_main.name
}

resource "aws_iam_policy_attachment" "ec2_main_to_ecr" {
  name       = "Access_ECR_from_EC2"
  roles      = [aws_iam_role.ec2_main.name]
  policy_arn = aws_iam_policy.ecr_read_only.arn
}

resource "aws_iam_policy" "ecr_read_write" {
  name        = "ECR_pull_and_push_image"
  description = "Policy for pushing and pull image from ECR"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : [
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:DescribeImageReplicationStatus",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:DeleteRepository",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:ReplicateImage",
          "ecr:GetLifecyclePolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:PutImageScanningConfiguration",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImage",
          "ecr:UntagResource",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:StartLifecyclePolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:GetRepositoryPolicy"
        ],
        Resource : "arn:aws:ecr:eu-central-1:*:repository/${var.project_name}-application"
      },
      {
        Sid : "VisualEditor1",
        Effect : "Allow",
        Action : [
          "ecr:GetRegistryPolicy",
          "ecr:BatchImportUpstreamImage",
          "ecr:CreateRepository",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:GetAuthorizationToken",
          "ecr:PutRegistryScanningConfiguration",
          "ecr:CreatePullThroughCacheRule",
          "ecr:DeletePullThroughCacheRule",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:PutReplicationConfiguration"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_user" "ecr_user_main" {
  name = "ecr_user"
}

resource "aws_iam_access_key" "main_key" {
  user = aws_iam_user.ecr_user_main.name
}

resource "aws_iam_user_policy_attachment" "gitlab_rw_policy" {
  user       = aws_iam_user.ecr_user_main.name
  policy_arn = aws_iam_policy.ecr_read_write.arn
}
