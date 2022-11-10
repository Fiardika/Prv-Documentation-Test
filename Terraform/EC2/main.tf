#AWS Instance
 resource "aws_instance" "instance" {

    ami                         = var.AMI
    instance_type               = var.INSTANCE_TYPE
    key_name                    = var.KEY
    subnet_id                   = var.SUBNET_ID1
    vpc_security_group_ids      = var.SECURITY_GROUP
    associate_public_ip_address = true

    root_block_device {
    volume_type            = "gp2"
    volume_size            = "30"
    delete_on_termination  = true
  }

    ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "8"
    volume_type = "gp2"
  }

    tags = {
    Name = "${var.PROJECT}-instance"
  }

    volume_tags = {
    Name = "${var.PROJECT}-volume"
  }

    provisioner "file" {
    source      = "default"
    destination = "/tmp/default"
  }

    provisioner "file" {
    source      = "installation.sh"
    destination = "/tmp/installation.sh"
  }

    connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/mnt/d/Terraform/EC2/dell.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -t rsa -f /home/ubuntu/.ssh/id_rsa -q -P ''",
      "chmod +x /tmp/installation.sh",
      ". /tmp/installation.sh"
    ]
  }
}

resource "aws_ami_from_instance" "Privy-AMI" {
  name               = "${var.PROJECT}-AMI"
  source_instance_id = aws_instance.instance.id
}