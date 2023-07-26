### ECR
resource "aws_ecr_repository" "market_ecr" {
  name         = "market_ecr"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
}


# 이미지 빌드, 푸시
resource "null_resource" "build_and_push_image_market_ecr" {
  # provisioner "local-exec" {
  #   command = "docker build -t user_server_img:latest ../user_server/"
  # }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.market_ecr.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.market_ecr.name} ../main"
  }

  provisioner "local-exec" {
    command = "docker tag ${aws_ecr_repository.market_ecr.name}:latest ${aws_ecr_repository.market_ecr.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.market_ecr.repository_url}:latest"
  }
}
