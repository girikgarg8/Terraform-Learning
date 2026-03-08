{
  "AWSPolicyFormatVersion": "2015-10-01",
  "RecordType": "A",
  "StartRule": "failover",
  "Endpoints": {
    "web-ec2": {
      "Type": "value",
      "Value": "${ec2_ip}"
    },
    "fallback": {
      "Type": "value",
      "Value": "1.1.1.1"
    }
  },
  "Rules": {
    "failover": {
      "RuleType": "failover",
      "Primary": {
        "EndpointReference": "web-ec2",
        "HealthCheck": "${health_check_id}"
      },
      "Secondary": {
        "EndpointReference": "fallback"
      }
    }
  }
}