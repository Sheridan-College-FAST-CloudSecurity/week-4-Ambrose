pipeline {
    agent any
    environment {
        IMAGE_TAG = "${GIT_COMMIT}"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-service:${IMAGE_TAG} .'
            }
        }
        stage('Push to ECR') {
            steps {
                sh 'docker tag my-service:${IMAGE_TAG} <ecr-repo>/my-service:${IMAGE_TAG}'
                sh 'docker push <ecr-repo>/my-service:${IMAGE_TAG}'
            }
        }
    }
}