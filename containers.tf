
# Create a ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_shortname}_ecs_cluster"
}

# Create a ECS task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "ecs_task_definition"
  container_definitions = file("./container_defs/containers.json")
}

# Create a ECS service
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_shortname}_ecs_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.dev_private_subnet[*].id
    security_groups  = [aws_security_group.ubuntu_sg.id]
    assign_public_ip = true
  }
}