resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
        {
            type = "metric"
            x = 0
            y = 0
            width = 12
            height = 6
            properties = {
                metrics = [
                    ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.main.id]
                ]
                view = "timeSeries"
                region = data.aws_region.current.id
                title = "CPU Utilization"
                period = 300
            }
        },
        {
            type   = "metric"
            x      = 12
            y      = 0
            width  = 12
            height = 6
            properties = {
                metrics = [
                    ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.main.id],
                    [".", "NetworkOut", ".", "."]
                ]
                view   = "timeSeries"
                region = data.aws_region.current.id
                title  = "Network (bytes In/Out)"
                period = 300
            }
        }
    ]
  })
}