pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '716619698758' // 🔁 replace with your AWS Account ID
        AWS_REGION = 'us-east-1'        // 🔁 replace with your region
        IMAGE_NAME = 'sampledockerimage'     // 🔁 any image name you want
        ECR_REPO   = "716619698758.dkr.ecr.us-east-1.amazonaws.com/sampledockerimage"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo 'Fetching code from GitHub...'
                git branch: 'main', changelog: false, poll: false, scm: scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: '468c71d6-8582-4692-bdaf-4df545d7856c', url: 'https://github.com/Yamini2022/jenkinspipeline.git']])
            }
        }

        stage('Build with Maven') {
            steps {
                echo 'Building application using Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                echo 'Authenticating Docker to AWS ECR...'
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} \
                    | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Tag and Push to ECR') {
            steps {
                echo 'Tagging and pushing image to AWS ECR...'
                sh '''
                    docker tag ${IMAGE_NAME}:latest ${ECR_REPO}:latest
                    docker push ${ECR_REPO}:latest
                '''
            }
        }

        stage('Clean Up') {
            steps {
                echo 'Cleaning up local Docker images...'
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
            echo '❌ Pipeline failed. Please check the logs.'
        }
    }
}
