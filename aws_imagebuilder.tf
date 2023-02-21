#
# The below is a hello world ami builder using AWS_Imagebuilder. 
#
resource "aws_imagebuilder_component" "example" {
    data                  = <<-EOT
        name: HelloWorldexampleingDocument
        description: This is hello world exampleing document.
        schemaVersion: 1.0
        phases:
          - name: build
            steps:
              - name: HelloWorldStep
                action: ExecuteBash
                inputs:
                  commands:
                    - echo "Hello World! Build."
          - name: validate
            steps:
              - name: HelloWorldStep
                action: ExecuteBash
                inputs:
                  commands:
                    - echo "Hello World! Validate."
          - name: example
            steps:
              - name: HelloWorldStep
                action: ExecuteBash
                inputs:
                  commands:
                    - echo "Hello World! example."
    EOT
    name     = "example"
    platform = "Linux"
    version  = "1.0.0"
}



resource "aws_imagebuilder_distribution_configuration" "example" {
  name = "manual_build_example-85fe2384-540c-47cb-a71c-36ad44083c59"
  distribution {
    ami_distribution_configuration {
      ami_tags = {
        environment = "example"
    }
  }
  region  = "eu-west-2"
}
}


resource "aws_imagebuilder_image_recipe" "example" {
  name = "example"
  component {
    component_arn = aws_imagebuilder_component.example.arn
  }
  
  parent_image = "arn:aws:imagebuilder:eu-west-2:aws:image/ubuntu-server-20-lts-x86/x.x.x"
  version = "1.0.0"
  working_directory = "/tmp"
}

resource "aws_imagebuilder_image_pipeline" "example" {
  name = "manual_build_example"
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
  distribution_configuration_arn = aws_imagebuilder_distribution_configuration.example.arn
  image_recipe_arn = aws_imagebuilder_image_recipe.example.arn
}

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  name = "manual_build_example-85fe2384-540c-47cb-a71c-36ad44083c59"
  instance_profile_name = "EC2InstanceProfileForImageBuilder"
  terminate_instance_on_failure = true
}
