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
          sh "docker build -t reddot:latest -f devops/Dockerfile ."
    } } } }

    stage('Deploy: Dev') { steps { container(name: 'helm') { script {
        echo "delpoying"
    } } } }
  }
}