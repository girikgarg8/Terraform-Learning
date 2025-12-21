# module "myappserver" {
#   source        = "./modules/webserver"
#   ami_id        = "ami-02b8269d5e85954ef"
#   instance_type = "t3.small"
#   public_key    = file("id_rsa.pub")
#   key_name      = "second-instance-key"
# }