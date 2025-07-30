pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "btthanhk4/skmz"       // Đổi thành repo Docker của bạn
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    KUBECONFIG = "/var/jenkins_home/.kube/config"
  }

  stages {
    stage('Clone') {
      steps {
        git 'https://github.com/btthanhk4/skmz.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh '''
            docker build -t $DOCKER_IMAGE:$IMAGE_TAG .
          '''
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',   // Cấu hình trên Jenkins
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $DOCKER_IMAGE:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        sh '''
          sed -i "s|image: .*|image: $DOCKER_IMAGE:$IMAGE_TAG|" k8s-deployment.yaml
          kubectl apply -f k8s-deployment.yaml
        '''
      }
    }
  }

  post {
    failure {
      echo '❌ CI/CD Pipeline failed!'
    }
    success {
      echo '✅ CI/CD Pipeline completed successfully!'
    }
  }
}
