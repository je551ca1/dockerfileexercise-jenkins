pipeline {
    agent any

    stages {

        stage('Init') {
            steps {
                sh '''
                    docker rm -f flask-app mynginx 2>/dev/null || true
                    docker network rm new-network 2>/dev/null || true
                    docker network create new-network
                '''
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    trivy fs --format json -o trivy-report.json .
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-report.json'
                }
            }
        }

        stage('Build') {
            steps {
                sh '''
                    docker build -t flask-app .
                '''

                sh '''
                    docker build -t mynginx -f Dockerfile.nginx .
                '''
            }
        }

        stage('Image Scan') {
            steps {
                sh '''
                    trivy image --format json \
                    -o trivy-image-report.json \
                    flask-app:latest
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-image-report.json'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker run -d \
                    --name flask-app \
                    --network new-network \
                    flask-app:latest
                '''

                sh '''
                    docker run -d \
                    -p 80:80 \
                    --name mynginx \
                    --network new-network \
                    mynginx:latest
                '''
            }
        }

        stage('Execute Tests') {
            steps {
                script {
                    catchError(
                        buildResult: 'UNSTABLE',
                        stageResult: 'UNSTABLE'
                    ) {
                        sh '''
                            python3 -m venv .venv

                            . .venv/bin/activate

                            pip install --upgrade pip

                            pip install -r requirements.txt

                            python3 -m unittest discover -s tests

                            deactivate
                        '''
                    }
                }
            }
        }

    }

    post {
        always {
            sh '''
                docker ps || true
            '''
        }
    }
}

