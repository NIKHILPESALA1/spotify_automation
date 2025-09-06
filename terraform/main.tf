# Pull Jenkins image
resource "docker_image" "jenkins_image" {
  name = "jenkins/jenkins:lts-jdk11"
}

# create a local directory for jenkins home (so data persists)
resource "null_resource" "ensure_jenkins_home" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/jenkins_home"
  }
}

# Run Jenkins container, mount docker socket so Jenkins can run docker commands (docker-in-docker style)
resource "docker_container" "jenkins" {
  name  = "local-jenkins"
  image = docker_image.jenkins_image.latest

  ports {
    internal = 8080
    external = 8080
  }

  volumes = [
    "${path.module}/jenkins_home:/var/jenkins_home",
    "/var/run/docker.sock:/var/run/docker.sock"
  ]

  # optional envs
  env = [
    "JAVA_OPTS=-Djenkins.install.runSetupWizard=false"
  ]
}

