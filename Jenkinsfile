pipeline {
    agent any

    environment {
        IMAGE = "btthanhk4/skmz"                     // Thay bằng Docker Hub repo của bạn
        TAG = "${env.BUILD_NUMBER}"                 // Tag là số build tự động
        REGISTRY_CREDENTIALS = 'dockerhub-creds'    // ID credential đã tạo trong Jenkins
        KUBE_CONFIG = credentials('kubeconfig')     // Kubeconfig nếu deploy từ Jenkins
    }

    stages {

        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/btthanhk4/skmz.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t $IMAGE:$TAG .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${REGISTRY_CREDENTIALS}") {
                        sh "docker push $IMAGE:$TAG"
                    }
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                script {
                    sh """
                    kubectl set image deployment/skmz-deployment skmz=$IMAGE:$TAG --kubeconfig=\$KUBE_CONFIG
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
