pipeline {
    agent any

    environment {
        // 🧭 AWS Configuration
        AWS_ACCOUNT_ID = '716619698758'       // 🔁 Your AWS Account ID
        AWS_REGION     = 'us-east-1'          // 🔁 Your AWS region
        IMAGE_NAME     = 'sampledockerimage'  // 🔁 Any Docker image name
        ECR_REPO       = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '📦 Fetching code from public GitHub repository...'
                git branch: 'main', url: 'https://github.com/Yamini2022/jenkinspipeline.git'
            }
        }

        stage('Build with Maven') {
            steps {
                echo '🔨 Building application using Maven...'
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
                echo '🔐 Authenticating Docker to AWS ECR...'
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} \
                    | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                echo '🚀 Tagging and pushing image to AWS ECR...'
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
            echo '✅ Pipeline completed successfully! Image pushed to AWS ECR.'
        }
        failure {
            echo '❌ Pipeline failed. Please check console output for errors.'
        }
    }
}
