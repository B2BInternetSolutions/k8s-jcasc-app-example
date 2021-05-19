pipeline {
  options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
  }
  agent {
      label 'gradle_java_node'
  }

  stages {
    stage('Build Gradle') { steps { container(name: 'gradle') { script {
        sh "gradle build"
    } } } }

    stage('Build NPM') { steps { container(name: 'node') { script {
        dir('node-ui') {
            sh "npm ci install"
        }
    } } } }

    stage('Build Docker') { steps { container(name: 'docker') { script {
        withCredentials([usernamePassword(credentialsId: 'github-gcr-docker-login', passwordVariable: 'DOCKER_PWD', usernameVariable: 'DOCKER_USR')]) {
            sh "echo ${DOCKER_PWD} | docker login ghcr.io -u ${DOCKER_PWD} --password-stdin"
        }

        // build and push the image
        sh "docker build -t reddot:latest -f devops/Dockerfile ."
        sh "docker image tag reddot:latest ghcr.io/ragin-lundf/k8s-jcasc-app-example/reddot/reddot:latest"
        sh "docker image push ghcr.io/ragin-lundf/k8s-jcasc-app-example/reddot/reddot:latest"
    } } } }

// --- This is only a simple example for a deployment. For regular deployments, please use the
// --- https://www.jenkins.io/doc/pipeline/steps/Parameterized-Remote-Trigger/ plugin
    stage('Deploy: Dev') { steps { container(name: 'helm') { script {
        echo "deploying dev..."
        sh "wget --auth-no-challenge --http-user=admin --http-password=admin http://jenkins-controller:8080/jenkins/view/Demo%20deploy/job/Deploy%20DEMO%20dev/build?token=6f33625a-667e-4043-97f5-a8341eb3fa4b"
    } } } }

    stage('Test E2E: Dev') { steps { container(name: 'helm') { script {
        // imaging, that we are testing something here
        sleep(120)
    } } } }

    stage('Undeploy: Dev') { steps { container(name: 'helm') { script {
        echo "Undeployin devg..."
        sh "wget --auth-no-challenge --http-user=admin --http-password=admin http://jenkins-controller:8080/jenkins/view/Demo%20deploy/job/Undeploy%20DEMO%20dev/build?token=e858d2ac-e4b7-45ff-827c-8ce58e9f7dea"
    } } } }

    stage('Deploy: Qa') { steps { container(name: 'helm') { script {
        echo "deploying qa..."
        sh "wget --auth-no-challenge --http-user=admin --http-password=admin http://jenkins-controller:8080/jenkins/view/Demo%20deploy/job/Deploy%20DEMO%20qa/build?token=28d29593-79f8-4d4a-a05b-2bf345316807"
    } } } }

  }
}