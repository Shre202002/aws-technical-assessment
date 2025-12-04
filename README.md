## **Problem Statement 1: Networking & Subnetting (AWS VPC Setup)**

Design and configure a basic AWS network with the following requirements:

1. Create 1 VPC
2. Create 2 Public Subnets
3. Create 2 Private Subnets
4. Attach an Internet Gateway (IGW)
5. Configure NAT Gateway for private subnet outbound access

**Screenshots:**

**VPC**

<img width="2879" height="1541" alt="VPC" src="https://github.com/user-attachments/assets/b2d7289b-ac0a-49e4-818d-a567369da8ae" />

**Subnets**

<img width="2879" height="1541" alt="Subnets" src="https://github.com/user-attachments/assets/cc311646-5b1f-47e4-93a6-3bb246534d65" />

**Route tables**

<img width="2879" height="1541" alt="Route tables" src="https://github.com/user-attachments/assets/fdd61b66-082c-46af-8bdf-8362bd54c927" />

**NAT Gateway**

<img width="2879" height="1541" alt="NAT Gateway" src="https://github.com/user-attachments/assets/5fc2aba2-e5af-4114-839c-960e5f3ffce4" />


---

## **Problem Statement 2: EC2 Static Website Hosting**

Deploy a static resume website on an EC2 instance using Nginx with the following requirements:

1. Launch a Free Tier EC2 instance in the public subnet
2. Install and configure Nginx
3. Host your resume as a static website
4. Ensure the site is accessible via public IP on port 80
5. Apply AWS best practices for basic infrastructure hardening

**Screenshots:**

**EC2 Instance**

<img width="2879" height="1541" alt="EC2 Instance" src="https://github.com/user-attachments/assets/e5e1b7a0-9e62-4a87-b0df-7db2d04f08f7" />

**Security Groups**

<img width="2879" height="1541" alt="Security Groups" src="https://github.com/user-attachments/assets/668ca69b-441d-4766-8065-5910574062f4" />

**Resume in Website**

<img width="2880" height="3381" alt="resume_website" src="https://github.com/user-attachments/assets/1955bb1e-dc88-49b1-8812-6ee92c120e13" />


---

## **Problem Statement 3: High Availability + Auto Scaling**

Enhance your architecture by migrating to a highly available setup:

1. Create an Internet-facing Application Load Balancer (ALB)
2. Migrate the EC2 instance setup to private subnets
3. Create an Auto Scaling Group (ASG) for high availability across AZs
4. Attach the ALB to the ASG
5. Ensure proper routing (public → ALB → private EC2 instances)

**Screenshots:**

**ALB**

<img width="2879" height="1541" alt="ALB" src="https://github.com/user-attachments/assets/2a50d2e8-5acd-414c-abb0-d199576fa0d1" />

**Target group**

<img width="2879" height="1541" alt="Target group" src="https://github.com/user-attachments/assets/ae439e84-3daf-4dbf-a79b-a481d625a815" />

**Auto Scaling Group**

<img width="2879" height="1541" alt="Auto Scaling Group" src="https://github.com/user-attachments/assets/56be95dc-b6d0-4f8b-9692-787fab1caf7b" />

**EC2 instances**

<img width="2879" height="1541" alt="EC2 instances launched via ASG" src="https://github.com/user-attachments/assets/a0362b09-3618-4fd4-b386-ccb0918bac10" />


---

## **Problem Statement 4: Billing & Free Tier Cost Monitoring**

Configure cost alerts on your AWS account:

1. Set a CloudWatch Billing Alarm at ₹100
2. Enable Free Tier usage alerts

**Screenshots:**

**CloudWatch Billing Alarm**

<img width="2880" height="2079" alt="CloudWatch Billing Alarm" src="https://github.com/user-attachments/assets/3f4696b0-8d9a-45d7-aad0-5de81619cab4" />

**Free Tier Usage Alerts**

<img width="2879" height="1541" alt="Free Tier Usage Alerts page" src="https://github.com/user-attachments/assets/9b296e17-a976-4c0f-8aa3-ea1863d37bce" />


---

## **Problem Statement 5: AWS Architecture Diagram (draw.io)**

Create an architecture diagram on draw.io for the following scenario:

**“Design an AWS architecture for a highly scalable web application capable of handling 10,000 concurrent users.”**

Your diagram must include:

1. Load Balancing (ALB)
2. Auto Scaling Group
3. Multi-tier networking (public/private subnets)
4. Scalable database layer (RDS/Aurora)
5. Caching (Redis/ElastiCache)
6. Security components (Security Groups, NACLs, WAF if applicable)
7. Observability (CloudWatch, Logs)
8. Any additional services you believe are necessary

**AWS Architecture Diagram**

<img width="411" height="311" alt="AWS Architecture Diagram Task drawio" src="https://github.com/user-attachments/assets/54851063-7f3c-4ddc-a0f4-eebede153631" />


---
