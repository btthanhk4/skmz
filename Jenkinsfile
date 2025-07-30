pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "btthanhk4/skmz:${env.BUILD_NUMBER}"     // Image tag
    KUBECONFIG = "/var/jenkins_home/.kube/config"           // Kube config path
  }

  stages {

    stage('Clone') {
      steps {
        git url: 'https://github.com/btthanhk4/skmz.git', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${DOCKER_IMAGE} ."
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          sh """
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
            docker push ${DOCKER_IMAGE}
          """
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        script {
          sh """
            sed -i 's|IMAGE_PLACEHOLDER|${DOCKER_IMAGE}|g' k8s/deployment.yaml
            kubectl apply -f k8s/deployment.yaml
            kubectl apply -f k8s/service.yaml || true
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ CI/CD Pipeline completed successfully!"
    }
    failure {
      echo "❌ CI/CD Pipeline failed!"
    }
  }
}
