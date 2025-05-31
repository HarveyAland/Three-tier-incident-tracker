resource "aws_db_subnet_group" "rds" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow inbound PostgreSQL from EKS"
  vpc_id      = var.vpc_id

  ingress {
    description              = "Allow PostgreSQL from EKS node group"
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.name_prefix}-postgres"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id,var.eks_node_sg_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false

  tags = {
    Name = "${var.name_prefix}-postgres"
  }
}

resource "aws_security_group_rule" "allow_postgres_from_eks" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.eks_node_sg_id
}