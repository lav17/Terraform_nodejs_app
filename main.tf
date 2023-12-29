terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "TF_VAR_CLOUDFRONT_IP" {}
variable "aws_region" {

}
variable "key_name" {}
variable "ec2_ami_id" {}


# Configure the AWS Provider
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.aws_region
}


# define ec2
#SG resource details
data "aws_vpc" "default" {
  default = true
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id


  ingress {
    description     = "nodejs port"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    prefix_list_ids = [var.TF_VAR_CLOUDFRONT_IP]
  }

  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "web" {
  ami                    = var.ec2_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = var.key_name

  tags = {
    Name = "Instance A"
  }

  user_data = file("script.sh")

}

# cloudfront configuration
locals {
  ec2_origin_id = "ec2Origin"
}

resource "aws_cloudfront_distribution" "ec2_distribution" {
  origin {
    domain_name = aws_instance.web.public_dns
    origin_id   = local.ec2_origin_id

    custom_origin_config {
      http_port              = 3000
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true #to enable it when it starts

  is_ipv6_enabled = true
  #default_root_object = "index.html" #root doc to display to client


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"] # how to get objects from bucket
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.ec2_origin_id # origin of object identified using s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only" # protocol used by user to access the content
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "developement"
  }

  viewer_certificate {
    cloudfront_default_certificate = true # required for usser to access the content over cloudfront domain
  }
}
