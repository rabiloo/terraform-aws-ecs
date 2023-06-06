resource "aws_ecs_cluster" "this" {
  name = var.name

  setting {

    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  tags = merge({ Name = var.name }, var.tags)
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    iterator = strategy

    content {
      capacity_provider = strategy.value["capacity_provider"]
      weight            = lookup(strategy.value, "weight", null)
      base              = lookup(strategy.value, "base", null)
    }
  }
}
