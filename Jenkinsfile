pipeline {
  agent any

  environment {
    IMAGE = "btthanhk4/skmz"
    TAG = "${env.BUILD_NUMBER}"
    DOCKER_IMAGE = "${IMAGE}:${TAG}"
    REGISTRY_CREDENTIALS = 'dockerhub-creds'
  }

  stages {
    stage('Clone') {
      steps {
        git url: 'https://github.com/btthanhk4/skmz.git', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKER_IMAGE} ."
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "${REGISTRY_CREDENTIALS}",
          usernameVariable: 'DOCKER_USERNAME',
          passwordVariable: 'DOCKER_PASSWORD'
        )]) {
          sh """
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
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
      echo '✅ CI/CD Pipeline completed successfully!'
    }
    failure {
      echo '❌ CI/CD Pipeline failed!'
    }
  }
}
