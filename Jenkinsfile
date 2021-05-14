pipeline {
  options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
  }
  agent {
      label 'gradle_node'
  }

  stages {
    stage('Build Gradle') { steps { container(name: 'gradle') { script {
        sh "./gradlew build"
    } } } }

    stage('Build NPM') { steps { container(name: 'node') { script {
        dir('ui') {
            sh "npm ci install"
        }
    } } } }

    stage('Build Docker') { steps { container(name: 'docker') { script {
          sh "docker build -t reddot:latest -f devops/Dockerfile ."
    } } } }
  }
}