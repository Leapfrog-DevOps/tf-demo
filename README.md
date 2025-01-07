[<img src="./leapfrog-logo.png" alt="WAF Logo" width="190" height="40">](https://www.lftechnology.com/)


# WAF and Shield Terraform Configuration [![AWS_logo](https://docs.aws.amazon.com/assets/r/images/aws_logo_dark.png)](https://aws.amazon.com/waf/)

## Overview
This repository contains Terraform configuration for deploying a WAF in AWS.

## Prerequisites
- Terraform installed
- AWS account with appropriate permissions
- AWS CLI configured
- AWS IAM user with appropriate permissions

## Purpose
This repository is designed to help deploy a WAF in AWS to help protect your web applications from common web exploits especially DDoS attacks and other malicious traffic. AWS Shield is also included in this configuration which helps protect your AWS resources from DDoS attacks as well.
- WAF
- WAF Rule
- WAF Rule Group
- WAF Rule Group Association


## Quick Start

1. **Terraform Initialization:**
   - `terraform init`

2. **Validation:**
   - `terraform validate`

3. **Plan:**
   - `terraform plan`

4. **Apply:**
   - `terraform apply`

Ensure to modify names and variables according to your specifications before deploying.
