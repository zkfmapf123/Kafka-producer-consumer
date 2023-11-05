locals {
  ec2_ins = {
    "producer-fluentbit" : "producer",
    "consumer" : "consumer"
  }
}

############################################################
### EC2 Security Group
############################################################
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "instance_sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "from to SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "from to HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "instance_sg"
    Resource = "sg"
  }
}

############################################################
### aws key pair
############################################################
resource "aws_key_pair" "key_pair" {
  key_name   = "kafka-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

############################################################
### EC2 IAM
############################################################
resource "aws_iam_role" "ec2-admin" {
  name = "ec2-admin"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ec2-admin-policy" {
  name = "ec2-admin-policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-admin-attach" {
  role       = aws_iam_role.ec2-admin.name
  policy_arn = aws_iam_policy.ec2-admin-policy.arn
}

resource "aws_iam_instance_profile" "ec2-admin-role-profile" {
  name = "ec2-admin-role"
  role = aws_iam_role.ec2-admin.name
}

############################################################
### EC2
############################################################
resource "aws_instance" "instance" {

  for_each = local.ec2_ins

  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = aws_key_pair.key_pair.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2-admin-role-profile.id

  root_block_device {
    volume_type = "gp3"
    volume_size = "30"
  }

  tags = {
    Name = each.value
  }
}
