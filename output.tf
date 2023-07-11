output Jenkins_url {
  value       = join ("",["http://", aws_instance.Jenkins.public_dns, ":", "8080"])
}
