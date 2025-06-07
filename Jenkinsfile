pipeline {
  agent any

  environment {
    AWS_REGION = 'eu-west-2'
    BACKEND_IMAGE = '637423629214.dkr.ecr.eu-west-2.amazonaws.com/major-incident-backend'
    FRONTEND_IMAGE = '637423629214.dkr.ecr.eu-west-2.amazonaws.com/major-incident-frontend'
  }

  stages {
    stage('Checkout Code') {
      steps {
        echo 'Cloning repository...'
        checkout scm
      }
    }

    stage('Build Backend Image') {
      steps {
        echo 'Building backend Docker image...'
        sh '''
          cd backend
          docker build -t $BACKEND_IMAGE:latest .
        '''
      }
    }

    stage('Build Frontend Image') {
      steps {
        echo 'Building frontend Docker image...'
        sh '''
          cd frontend
          npm install
          npm run build
          docker build -t $FRONTEND_IMAGE:latest .
        '''
      }
    }

    stage('Login to Amazon ECR') {
      steps {
        echo 'Logging in to Amazon ECR...'
        sh '''
          aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin 637423629214.dkr.ecr.eu-west-2.amazonaws.com
        '''
      }
    }

    stage('Push Images to ECR') {
      steps {
        echo 'Pushing Docker images to ECR...'
        sh '''
          docker push $BACKEND_IMAGE:latest
          docker push $FRONTEND_IMAGE:latest
        '''
      }
    }

    stage('Update Kubernetes Deployments') {
      steps {
        echo 'Updating EKS deployments with new images...'
        sh '''
          kubectl set image deployment/backend backend=$BACKEND_IMAGE:latest
          kubectl set image deployment/frontend frontend=$FRONTEND_IMAGE:latest
        '''
      }
    }
  }

  post {
    success {
      echo 'CI/CD pipeline completed successfully.'
    }
    failure {
      echo 'Pipeline failed. Check the logs for details.'
    }
  }
}