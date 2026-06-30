pipeline {
    agent any

    environment {
        AWS_REGION   = 'us-east-2'
        ECR_REGISTRY = '149465511648.dkr.ecr.us-east-2.amazonaws.com'
        IMAGE_TAG    = "${env.GIT_COMMIT.take(7)}"
    }

    stages {
        stage('Build & Push Backend') {
            when {
                changeset "backend/**"
            }
            steps {
                dir('backend') {
                    sh "docker build --platform linux/amd64 -t ${ECR_REGISTRY}/tc1-dev-backend:${IMAGE_TAG} ."
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    sh "docker push ${ECR_REGISTRY}/tc1-dev-backend:${IMAGE_TAG}"
                    sh "aws ecs update-service --cluster tc1-dev-cluster --service tc1-dev-backend-service --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }

        stage('Build & Push Frontend') {
            when {
                changeset "frontend/**"
            }
            steps {
                dir('frontend') {
                    sh "docker build --platform linux/amd64 --build-arg REACT_APP_API_URL=/api -t ${ECR_REGISTRY}/tc1-dev-frontend:${IMAGE_TAG} ."
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    sh "docker push ${ECR_REGISTRY}/tc1-dev-frontend:${IMAGE_TAG}"
                    sh "aws ecs update-service --cluster tc1-dev-cluster --service tc1-dev-frontend-service --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }
    }
}
