pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/franking66/fireblocks_assignment_docker_solution.git'
            }
        }

        stage('Run Test Script') {
            steps {
                sh 'python3 test.py'
            }
        }
    }
}

