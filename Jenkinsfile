pipeline {
  options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
  }
  agent {
      label 'gradle_java_node'
  }

  stages {
    stage('Build Gradle') { steps { container(name: 'gradle') { script {
        sh "./gradlew build"
    } } } }

    stage('Build NPM') { steps { container(name: 'node') { script {
        dir('node-ui') {
            sh "npm ci install"
        }
    } } } }

    stage('Build Docker') { steps { container(name: 'docker') { script {
        // Setup an insecure registry for the demo case
        echo "{ \"insecure-registries\" : [\"docker-registry.demo.svc.cluster.local:5000\"] }" > /etc/docker/daemon.json

        // build and push the image
        sh "docker build -t reddot:latest -f devops/Dockerfile ."
        sh "docker image tag reddot:latest docker-registry.demo.svc.cluster.local:5000/reddot/reddot:latest"
        sh "docker image push docker-registry.demo.svc.cluster.local:5000/reddot/reddot:latest"
    } } } }

    stage('Deploy: Dev') { steps { container(name: 'helm') { script {
        echo "delpoying..."
        sh "wget --auth-no-challenge --http-user=admin --http-password=admin http://jenkins-controller:8080/jenkins/view/Demo%20deploy/job/Deploy%20DEMO%20dev/build?token=6f33625a-667e-4043-97f5-a8341eb3fa4b"
    } } } }
  }
}