pipeline {
    agent any

    stages {

        stage('Cleanup') {
            steps {
                sh '''
                    docker rm -f flask-app || true
                    docker network rm app-network || true
                '''
            }
        }

        stage('Setup Network') {
            steps {
                sh '''
                    docker network create app-network || true
                '''
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    docker build -t flask-app-image .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker run -d \
                    --name flask-app \
                    --network app-network \
                    -p 5000:5000 \
                    flask-app-image
                '''
            }
        }

    }
}
