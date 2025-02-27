pipeline {
    agent any
    #options {
    #    // Prevent Jenkins from doing an automatic SCM checkout.
    #    skipDefaultCheckout()
    #}
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir() // Clean up any previous workspace files.
            }
        }
        stage('Checkout') {
            steps {
                // Manually check out your repository.
                git branch: 'main', url: 'https://github.com/franking66/fireblocks_assignment_docker_solution.git'
            }
        }
        stage('Run Test Script') {
            steps {
                sh 'chmod +x test.sh && ./test.sh'
            }
        }
    }
}
