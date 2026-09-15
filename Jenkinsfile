pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Test') {
            steps {
                bat 'mvnw.cmd -B clean verify'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build --tag devops-demo:%BUILD_NUMBER% .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    script {
                        try {
                            bat '''
                                @echo off
                                echo %DOCKERHUB_TOKEN%| docker login --username %DOCKERHUB_USERNAME% --password-stdin
                            '''

                            bat '''
                                docker tag devops-demo:%BUILD_NUMBER% %DOCKERHUB_USERNAME%/devops-demo:%BUILD_NUMBER%
                            '''

                            bat '''
                                docker push %DOCKERHUB_USERNAME%/devops-demo:%BUILD_NUMBER%
                            '''
                        } finally {
                            bat(
                                returnStatus: true,
                                script: 'docker logout'
                            )
                        }
                    }
                }
            }
        }

        stage('Archive JAR') {
            steps {
                archiveArtifacts(
                    artifacts: 'target/*.jar',
                    fingerprint: true
                )
            }
        }
    }

    post {
        always {
            junit(
                testResults: 'target/surefire-reports/*.xml',
                allowEmptyResults: true
            )
        }

        success {
            echo 'CI pipeline completed successfully.'
        }

        failure {
            echo 'CI pipeline failed. Review the stage logs.'
        }
    }
}