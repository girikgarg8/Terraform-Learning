module "mywebserver" {
  source        = "./modules/webserver"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  public_key    = file("id_rsa.pub")
  key_name      = "first-instance-key"
}

output "myinstancepublicip" {
    # get the public ip corresponding to parent module "mywebserver"
    value = module.mywebserver.instancepublicip
}