pipeline {
    agent any

    environment {
        IMAGE = "btthanhk4/skmz"
        TAG = "${env.BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = 'dockerhub-creds'
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
                    sh "docker build -t $IMAGE:$TAG ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', REGISTRY_CREDENTIALS) {
                        sh "docker push $IMAGE:$TAG"
                    }
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                sh "kubectl apply -f k8s-deployment.yaml"
            }
        }
    }
}
