[<img src="./leapfrog-logo.png" alt="Leapfrog Logo" width="190" height="40">](https://www.lftechnology.com/)

# AWS WAF Implementation with ALB and EC2 [![AWS_logo](https://docs.aws.amazon.com/assets/r/images/aws_logo_light.svg)](https://aws.amazon.com/waf/)

## Overview
This repository contains Terraform configurations to implement AWS WAF (Web Application Firewall) for securing applications running on EC2 instances behind an Application Load Balancer (ALB).

## Architecture
`Internet → WAF → ALB → EC2 Instances`

![alt text](<WAF with ALB.png>)


## Features
- AWS WAF implementation with custom rule sets
- ALB integration with WAF
- EC2 instance configuration
- Security group configurations
- Automated deployment using Terraform

## Prerequisites
- Terraform >= 5.82.0
- AWS CLI configured with appropriate credentials
- IAM permissions for:
  - WAF
  - EC2
  - ALB
  - Security Groups
  - VPC

## Components
1. **WAF Configuration**
   - Custom rule groups
   - Rate limiting rules
   - IP blacklisting/whitelisting
   - SQL injection protection
   - XSS protection

2. **ALB Setup**
   - HTTPS listener
   - Target group configuration
   - Health checks

3. **EC2 Configuration**
   - Auto Scaling Group
   - Security groups
   - Instance profile


## Quick Start

1. Clone the Repository
    ```bash
    git clone https://github.com/Leapfrog-DevOps/tf-demo.git
    ```

2. Configure Variables
    - Update `terraform.tfvars` with your specific values
    - Modify region and environment settings as needed

3. Initialize Terraform
    ```bash
    terraform init
    ```

4. Validate Configuration
    ```bash
    terraform validate
    ```

5. Review the Plan
    ```bash
    terraform plan
    ```

6. Apply Configuration
    ```bash
    terraform apply
    ```


## WAF Rules Included
1. Rate-based rules for DDoS protection
2. AWS Managed Rules
    - Common Rule Set (CRS)
    - SQL injection prevention
    - Cross-site scripting (XSS) prevention
    - Bad bots protection
    - Bad input rule set
    - Admin Protection Rule Set
4. Geographic-based rules

## Maintenance
1. Regular updates of WAF rules
2. Monitoring and logging configuration
3. Performance optimization
4. Security patch management

## Best Practices
1. Always use HTTPS
2. Implement proper logging
3. Regular security audits
4. Keep WAF rules updated
5. Monitor WAF metrics

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request


> **ⓘ Info:** This repo includes a simple implementation of AWS WAF with ALB and EC2. It is intended for understanding the creation of WAF and attach it with certain service and may not be suitable for production use.
> There are a lot need to be changed and improved according to the needs and requirements.


## Support
For support, please contact the DevOps team or raise an issue in the repository.
