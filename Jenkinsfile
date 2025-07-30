pipeline {
  agent any

  environment {
    IMAGE = "btthanhk4/skmz"
    TAG = "${BUILD_NUMBER}"
    DOCKER_IMAGE = "${IMAGE}:${TAG}"
    REGISTRY_CREDENTIALS = "dockerhub-creds"
  }

  stages {
    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKER_IMAGE} ."
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "${REGISTRY_CREDENTIALS}",
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh """
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${DOCKER_IMAGE}
          """
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        sh """
          mkdir -p \$HOME/.kube
          cp /var/jenkins_home/.kube/config \$HOME/.kube/config
          kubectl set image deployment/skmz-deployment skmz=${DOCKER_IMAGE} -n default
        """
      }
    }
  }

  post {
    success {
      echo '✅ CI/CD Pipeline done!'
    }
    failure {
      echo '❌ Pipeline failed.'
    }
  }
}
