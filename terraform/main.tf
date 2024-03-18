terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


# Create ECS Cluster
resource "aws_ecs_cluster" "mycluster" {
  name = "WebApp-cluster"
}

# Create Task definition
resource "aws_ecs_task_definition" "app-TD" {
  family                   = "webAppTD"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
 
[
  {
    "name": "serverinfo-App",
    "image": "public.ecr.aws/d0z4x7p7/oyohedmond/serverinfo",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [ 
      {
          "containerPort": 3000,
          "hostPort"      : 3000
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


# creating service
resource "aws_ecs_service" "webApp-service" {
  name            = "task-service"
  cluster         = "${aws_ecs_cluster.mycluster.id}"
  task_definition = "${aws_ecs_task_definition.app-TD.arn}"
  desired_count   = 2 #make it a variable

  load_balancer {
    target_group_arn = "${aws_lb_target_group.app-service-tg.arn}"
    container_name   = "serverinfo-App" #
    container_port   = 3000 #make it is variable
  }

  network_configuration {
    security_groups = [data.aws_security_group.default.id]
    assign_public_ip = true 
    subnets         = "${data.aws_subnets.example.ids}"
  }


  launch_type               = "FARGATE"
 
}


# networking

# using default vpc
data "aws_vpc" "selected" {
  default = true
}

# retrieve information about subnet IDs within a specific VPC
data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}
output "subnet_ids" {
  value = data.aws_subnets.example.ids
}



# using a default security group
data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}



# load balancer
resource "aws_lb" "app-service-lb" {
  name = "app-service-alb"
  internal = false
  load_balancer_type = "application"
  subnets            = "${data.aws_subnets.example.ids}"

}

resource "aws_lb_target_group" "app-service-tg" {
  name = "app-tg"
  protocol = "HTTP"
  target_type = "ip"
  port        = 80
  vpc_id      = data.aws_vpc.selected.id
  health_check {
    protocol = "HTTP"
    path = "/"
  }
}
resource "aws_lb_listener" "app-service-lb_listener" {
  load_balancer_arn = "${aws_lb.app-service-lb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.app-service-tg.arn}"
  }
}

