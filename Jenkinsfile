pipeline {
  agent any
  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-creds')
  }
  stages {
    stage('Clone') {
      steps {
        git 'https://github.com/btthanhk4/skmz.git'
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t btthanhk4/skmz:latest .'
      }
    }
    stage('Push') {
      steps {
        sh '''
          echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS_USR" --password-stdin
          docker push btthanhk4/skmz:latest
        '''
      }
    }
    stage('Deploy to K8s') {
      steps {
        sh 'kubectl apply -f k8s-deployment.yaml'
      }
    }
  }
}
