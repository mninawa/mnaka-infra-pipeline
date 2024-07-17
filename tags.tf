locals { 
  common_tags = { 
    environment     = "${lower(var.ENV)}" 
    project         = "AWS CI/CD Pipeline Mnaka-int"
    managedby       = "Paige Mkoko"
  } 
}