resource "null_resource" "hello" {
  provisioner "local-exec" {
    # command = "echo 'Hello ${var.name}'"
    command = "echo 'Hello Eysi'"
  }
}

output "message" {
  # value = "Message is: ${var.name}"
  value = "Message is: Eysi"
}
