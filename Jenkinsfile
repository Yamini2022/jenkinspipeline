pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '716619698758'      // Replace with your AWS Account ID
        AWS_REGION = 'us-east-1'             // Replace with your region
        IMAGE_NAME = 'sampledockerimage'
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📦 Fetching code from GitHub...'
                git branch: 'main', url: 'https://github.com/Yamini2022/jenkinspipeline.git'
            }
        }

        stage('Build with Maven') {
            steps {
                echo '🔨 Building the application using Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                echo '🔐 Logging in to AWS ECR...'
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} \
                        | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Tag & Push Docker Image') {
            steps {
                echo '🚀 Tagging and pushing Docker image to ECR...'
                sh '''
                    docker tag ${IMAGE_NAME}:latest ${ECR_REPO}:latest
                    docker push ${ECR_REPO}:latest
                '''
            }
        }

        stage('Clean Up') {
            steps {
                echo '🧹 Cleaning up local Docker images...'
                sh '''
                    docker rmi ${IMAGE_NAME}:latest || true
                    docker rmi ${ECR_REPO}:latest || true
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check console output for details.'
        }
    }
}
