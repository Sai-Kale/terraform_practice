#data "template_file" "policy" {
  #template = "${file("${path.module}/policy.json")}"
#vars {                               #to create vars while creating policies example  to provide access to different bucket names
#    bucket_name = "dummy_bucket"
#  }
#}