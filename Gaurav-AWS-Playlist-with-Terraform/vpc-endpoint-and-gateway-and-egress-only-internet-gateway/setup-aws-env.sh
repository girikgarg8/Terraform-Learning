#!/bin/bash
# AWS CLI Environment Setup Script
# Run this on EC2 instances before testing AWS CLI commands
#
# Usage: source setup-aws-env.sh
#    or: . setup-aws-env.sh

echo "Setting up AWS CLI environment..."

# Set region to avoid auto-detection issues
export AWS_DEFAULT_REGION=ap-south-1

# Configure metadata service to avoid hanging
export AWS_EC2_METADATA_SERVICE_ENDPOINT_MODE=IPv4
export AWS_EC2_METADATA_SERVICE_ENDPOINT=http://169.254.169.254

echo "✅ AWS CLI environment configured!"
echo ""
echo "Test commands:"
echo "  Gateway Demo (S3):     aws s3 ls"
echo "  Interface Demo (EC2):  aws ec2 describe-instances"
echo "  Check credentials:     aws sts get-caller-identity"
echo ""
echo "To make permanent, add these to ~/.bashrc:"
echo "  echo 'export AWS_DEFAULT_REGION=ap-south-1' >> ~/.bashrc"
echo "  echo 'export AWS_EC2_METADATA_SERVICE_ENDPOINT_MODE=IPv4' >> ~/.bashrc"
echo "  echo 'export AWS_EC2_METADATA_SERVICE_ENDPOINT=http://169.254.169.254' >> ~/.bashrc"