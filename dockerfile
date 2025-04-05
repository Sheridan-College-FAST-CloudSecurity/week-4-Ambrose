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
                    credentialsId: 'github-ASIA55PYWAQOTDA3DUCD'
                )
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    env.IMAGE_TAG = "${env.BUILD_NUMBER ?: 'latest'}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-service:${IMAGE_TAG} .'
            }
        }

        stage('Authenticate to Amazon ECR') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'aws-session-token', variable: 'AWS_SESSION_TOKEN')
                ]) {
                    sh """
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin 956688630813.dkr.ecr.us-east-1.amazonaws.com
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh """
                    docker tag my-service:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                    docker push ${ECR_URI}:${IMAGE_TAG}
                """
            }
        }
    }
}
