pipeline {
    agent any

    environment {
        GETH_IMAGE = "fireblocks/geth-node:latest"
        PRYSM_IMAGE = "fireblocks/prysm-node:latest"
        GETH_DATA_DIR = "/var/lib/docker-volumes/geth"
        PRYSM_DATA_DIR = "/var/lib/docker-volumes/prysm"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/franking66/fireblocks_assignment_docker_solution.git'
            }
        }

        stage('Build Geth Docker Image') {
            steps {
                sh '''
                docker build -t ${GETH_IMAGE} -f Dockerfile.geth .
                '''
            }
        }

        stage('Build Prysm Docker Image') {
            steps {
                sh '''
                docker build -t ${PRYSM_IMAGE} -f Dockerfile.prysm .
                '''
            }
        }

        stage('Update Docker Registry') {
            steps {
                sh '''
                echo "!Q@W#E4r5t6y" | docker login -u "messagefrank@outlook.com" --password-stdin
                docker push ${GETH_IMAGE}
                docker push ${PRYSM_IMAGE}
                '''
            }
        }

        stage('Launch Containers') {
            steps {
                sh '''
                docker stop geth-node || true
                docker rm geth-node || true
                docker stop prysm-node || true
                docker rm prysm-node || true
                
                docker run -d --name geth-node --restart unless-stopped \
                    -v '${GETH_DATA_DIR}:/root/.ethereum' \
                    -p 30303:30303 -p 30303:30303/udp \
                    -p 8545:8545 -p 8546:8546 -p 8551:8551 \
                    ${GETH_IMAGE}
                
                docker run -d --name prysm-node --restart unless-stopped \
                    -v '${PRYSM_DATA_DIR}:/data' \
                    -p 4000:4000 \
                    ${PRYSM_IMAGE}
                '''
            }
        }
    }

    post {
        success {
            echo "Ethereum Geth and Prysm nodes deployed successfully!"
        }
        failure {
            echo "Deployment failed. Check logs."
        }
    }
}
