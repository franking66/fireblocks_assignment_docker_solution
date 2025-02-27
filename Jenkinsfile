pipeline {
    agent any
    options {
        // Prevent Jenkins from doing an automatic SCM checkout.
        skipDefaultCheckout()
    }

    environment {
        GETH_IMAGE = "fireblocks/geth-node:latest"
        PRYSM_IMAGE = "fireblocks/prysm-node:latest"
        GETH_DATA_DIR = "/var/lib/docker-volumes/geth"
        PRYSM_DATA_DIR = "/var/lib/docker-volumes/prysm"
    }

    stages {
        // stage('Clean Workspace') {
        //     steps {
        //         cleanWs()
        //     }
        // }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/franking66/fireblocks_assignment_docker_solution.git'
            }
        }

        stage('Create Dockerfiles') {
            steps {
                sh '''
                cat <<EOF > Dockerfile.geth
                FROM ubuntu:latest
                RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y software-properties-common \
                    && add-apt-repository -y ppa:ethereum/ethereum \
                    && apt-get update && apt-get install -y ethereum
                VOLUME ["/root/.ethereum"]
                EXPOSE 30303 30303/udp 8545 8546 8551
                CMD ["geth", "--syncmode", "light", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "eth,net,web3,admin", "--ws", "--ws.addr", "0.0.0.0", "--ws.port", "8546", "--bootnodes", "enode://<EthereumFoundationBootNodes>"]
                EOF
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                docker build -t ${GETH_IMAGE} -f Dockerfile.geth .
                '''
            }
        }

        stage('Update Docker Registry') {
            steps {
                sh '''
                docker login -u <your-dockerhub-username> -p <your-password>
                docker push ${GETH_IMAGE}
                '''
            }
        }

        stage('Launch Containers') {
            steps {
                sh '''
                docker stop geth-node || true
                docker rm geth-node || true
                docker run -d --name geth-node --restart unless-stopped \
                    -v ${GETH_DATA_DIR}:/root/.ethereum \
                    -p 30303:30303 -p 30303:30303/udp \
                    -p 8545:8545 -p 8546:8546 -p 8551:8551 \
                    ${GETH_IMAGE}
                '''
            }
        }
    }

    post {
        success {
            echo "Ethereum Geth node deployed successfully!"
        }
        failure {
            echo "Deployment failed. Check logs."
        }
    }
}
