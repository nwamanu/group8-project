#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "decouplecluster" {
  name = "uidecuople-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

