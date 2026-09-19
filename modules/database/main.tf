resource "aws_security_group" "database-sgrp" {
  name        = "sgrp-database"
  description = "Allow inbound traffic from application security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow traffic from application layer"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  engine                 = "postgres"
  engine_version         = "18.6"
  instance_class         = "db.t3.micro"
  multi_az               = true
  db_name                = "mydb"
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sgrp.id]
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = [var.public_subnet_1, var.public_subnet_2]

}