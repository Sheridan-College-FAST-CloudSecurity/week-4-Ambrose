pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_URI = '956688630813.dkr.ecr.us-east-1.amazonaws.com/assign2/dockerimage/my-service'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git(
                    url: 'https://github.com/Sheridan-College-FAST-CloudSecurity/week-4-Ambrose.git',
                    branch: 'main',
                    credentialsId: 'github-credential'
                )
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    env.IMAGE_TAG = "${GIT_COMMIT ?: 'latest'}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-service:${IMAGE_TAG} .'
            }
        }

        stage('Authenticate to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_URI}
                """
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                    docker tag my-service:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                    docker push ${ECR_URI}:${IMAGE_TAG}
                """
            }
        }
    }
}
