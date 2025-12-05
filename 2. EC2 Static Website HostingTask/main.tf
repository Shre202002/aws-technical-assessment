terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "sriyash_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sriyansh_vpc"
  }
}

resource "aws_internet_gateway" "sriyansh_igw" {
  vpc_id = aws_vpc.sriyansh_vpc.id

  tags = {
    Name = "sriyansh_igw"
  }
}

resource "aws_subnet" "sriyansh_public_subnet" {
  vpc_id                  = aws_vpc.sriyansh_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "sriyansh_public_subnet"
  }
}

resource "aws_route_table" "sriyansh_public_rt" {
  vpc_id = aws_vpc.sriyansh_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sriyansh_igw.id
  }

  tags = {
    Name = "sriyansh_public_rt"
  }
}

resource "aws_route_table_association" "sriyansh_public_rta" {
  subnet_id      = aws_subnet.sriyansh_public_subnet.id
  route_table_id = aws_route_table.sriyansh_public_rt.id
}

resource "aws_security_group" "sriyansh_sg" {
  name        = "sriyansh_sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.sriyansh_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "sriyansh_sg"
  }
}

resource "aws_iam_role" "sriyansh_ec2_role" {
  name = "sriyansh_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "sriyansh_ec2_role"
  }
}

resource "aws_iam_instance_profile" "sriyansh_instance_profile" {
  name = "sriyansh_instance_profile"
  role = aws_iam_role.sriyansh_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "sriyansh_ssm_policy" {
  role       = aws_iam_role.sriyansh_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "sriyansh_ec2" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.sriyansh_public_subnet.id
  vpc_security_group_ids = [aws_security_group.sriyansh_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.sriyansh_instance_profile.name
  key_name               = aws_key_pair.sriyansh_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Vishnu Pandey - Resume</title>
                  <style>
                      body { font-family: Arial, sans-serif; line-height: 1.6; margin: 0; padding: 20px; background-color: #f4f4f4; }
                      .container { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
                      h1, h2 { color: #333; }
                      .section { margin-bottom: 20px; }
                      .contact-info { margin-bottom: 20px; }
                      .contact-info p { margin: 5px 0; }
                      .skills ul { list-style-type: none; padding: 0; }
                      .skills li { display: inline-block; background: #e4e4e4; padding: 5px 10px; margin: 5px; border-radius: 3px; }
                      .project, .education-item, .certificate { margin-bottom: 15px; }
                      .date { color: #666; font-style: italic; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>Vishnu Pandey</h1>
                      <div class="contact-info">
                          <p>Email: vishnupandey082@gmail.com</p>
                          <p>Phone: +91 8858117599</p>
                          <p>LinkedIn: <a href="https://linkedin.com/in/vishnupandey082">linkedin.com/in/vishnupandey082</a></p>
                          <p>GitHub: <a href="https://github.com/thatismygit">github.com/thatismygit</a></p>
                      </div>
                      
                      <div class="section">
                          <h2>Computer Science Graduate</h2>
                          <p>I'm a Computer Science graduate passionate about cloud technologies and implementing DevOps solutions. From dockerizing applications to orchestrating them, I focus on building robust, scalable cloud architectures while maintaining strong security practices.</p>
                      </div>
                      
                      <div class="section">
                          <h2>Education</h2>
                          <div class="education-item">
                              <h3>M.C.A. - Computer Applications</h3>
                              <p>Pranveer Singh Institute of Technology</p>
                              <p class="date">09/2024 - Present</p>
                              <p>Courses</p>
                          </div>
                          <div class="education-item">
                              <h3>B.C.A. - Computer Applications</h3>
                              <p>MCU, Bhopal</p>
                              <p class="date">10/2020 - 05/2023</p>
                              <p>Courses</p>
                          </div>
                          <div class="education-item">
                              <h3>Senior Secondary</h3>
                              <p>Shri Ram Public School</p>
                              <p class="date">01/2019 - 01/2020</p>
                              <p>Courses</p>
                          </div>
                          <div class="education-item">
                              <h3>Higher Secondary</h3>
                              <p>Shri Ram Public School</p>
                              <p class="date">01/2018 - 01/2019</p>
                              <p>Courses</p>
                          </div>
                      </div>
                      
                      <div class="section skills">
                          <h2>Skills</h2>
                          <ul>
                              <li>AWS</li>
                              <li>Docker</li>
                              <li>Python</li>
                              <li>Linux</li>
                              <li>Git</li>
                              <li>Machine Learning</li>
                              <li>MCP</li>
                          </ul>
                      </div>
                      
                      <div class="section">
                          <h2>Personal Projects</h2>
                          <div class="project">
                              <h3>OpenTelemetry Demo (Ongoing)</h3>
                              <p>It is a polyglot, distributed system that simulates an online store selling space-themed products. It is a reference microservices application created by the OpenTelemetry community.</p>
                          </div>
                          <div class="project">
                              <h3>Model Context Protocol (MCP) server using PostgreSQL</h3>
                              <p>A Model Context Protocol (MCP) server using PostgreSQL enables AI assistants and large language models (LLMs) to interact with a PostgreSQL database in a secure and structured manner. This integration allows AI agents to query the database, understand its schema, and retrieve data without needing to copy/paste information or rely on traditional API integrations.</p>
                          </div>
                          <div class="project">
                              <h3>Genre Classification</h3>
                              <p>This project classifies music genres using text features extracted from metadata. I applied TF-IDF for feature representation and trained models like Logistic Regression and Random Forest. The workflow included preprocessing, feature extraction, model training, and evaluation, achieving strong classification performance across multiple genres.</p>
                          </div>
                      </div>
                      
                      <div class="section">
                          <h2>Certificates</h2>
                          <div class="certificate">
                              <h3>AWS Certified Cloud Practitioner (CLF-C02)</h3>
                          </div>
                          <div class="certificate">
                              <h3>HashiCorp Certified: Terraform Associate (003)</h3>
                          </div>
                      </div>
                  </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name = "sriyansh_ec2"
  }
}

resource "aws_key_pair" "sriyansh_key" {
  key_name   = "sriyansh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCU0psELucFow+jlyF+/5uiLdI+BNMu2BBIIxaH6ktkWsadq9Ft7BYO2lQPAeGmHBPCs+B2BeePRETEnvM+LmxVKL11neVJiraUjvFnpF86nMkjd2WChahvGJ6VZmocVqUOciYmvQVwqaINlq92cuBDfoe5zzfcWWocZ/r5owi3sIHz8AC3NWYziLahJbrdbH6sZalpSjOxkCR5ar9LdLPqjysvoKbtqP5NDSbPbWZIC88bBBz2RV2xDm+RONN1ELxYp6WQU+DEqiXGCah5QDOjjCjdRBodM3DAEhnhpqPXY5oXd+tS2/OHa1WNtrIT/Q7KAzfBswSwMrcmgWOMrhsz vishnupandey@fedora"
}

resource "aws_cloudwatch_log_group" "sriyansh_log_group" {
  name              = "/aws/ec2/sriyansh_ec2"
  retention_in_days = 7
}
