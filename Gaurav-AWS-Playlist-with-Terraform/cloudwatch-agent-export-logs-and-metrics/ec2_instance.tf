resource "aws_security_group" "main" {
  name        = "cloudwatch-agent-demo-sg"
  description = "Allow SSH for EC2 Instance Connect"
  vpc_id      = data.aws_vpc.default.id

  ingress {
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
}

locals {
  cw_agent_config = jsonencode({
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "cwagent"
    }
    logs = {
      logs_collected = {
        files = {
          collect_list = [
            {
              file_path         = "/var/log/messages"
              log_group_name   = var.log_group_name
              log_stream_name  = "{instance_id}/var/log/messages"
              retention_in_days = 7
            }
          ]
        }
      }
    }
    metrics = {
      namespace = var.metrics_namespace
      metrics_collected = {
        cpu = {
          measurement                 = ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"]
          metrics_collection_interval = 60
          resources                   = ["*"]
        }
        disk = {
          measurement                 = ["used_percent"]
          metrics_collection_interval = 60
          resources                   = ["*"]
        }
        mem = {
          measurement                 = ["mem_used_percent"]
          metrics_collection_interval = 60
        }
      }
    }
  })
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  iam_instance_profile   = aws_iam_instance_profile.cw_agent.name
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<-EOT
#!/bin/bash
set -e
yum install -y amazon-cloudwatch-agent
for f in /var/log/messages /var/log/secure; do [ -f "$f" ] && chmod 644 "$f" || true; done
getent group adm &>/dev/null && usermod -aG adm cwagent 2>/dev/null || true
getent group systemd-journal &>/dev/null && usermod -aG systemd-journal cwagent 2>/dev/null || true
echo '${base64encode(local.cw_agent_config)}' | base64 -d > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json || true
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start || true
systemctl enable amazon-cloudwatch-agent 2>/dev/null || true
EOT

    tags = {
      Name = "cloudwatch-agent-demo"
    }
}