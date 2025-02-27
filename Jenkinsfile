pipeline {
    agent any

    environment {
        GETH_IMAGE = "fireblocks/geth-node:latest"
        PRYSM_IMAGE = "fireblocks/prysm-node:latest"
        GETH_DATA_DIR = "geth_data"
        PRYSM_DATA_DIR = "prysm_data"
    }

    stages {
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
                RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:ethereum/ethereum && apt-get update && apt-get install -y ethereum
                VOLUME ["/root/.ethereum"]
                EXPOSE 30303 30303/udp 8545 8546 8551
                CMD ["geth", "--syncmode", "light", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "eth,net,web3,admin", "--ws", "--ws.addr", "0.0.0.0", "--ws.port", "8546", "--bootnodes", "enode://<EthereumFoundationBootNodes>"]
                EOF
                
                cat <<EOF > Dockerfile.prysm
                FROM ubuntu:latest
                RUN apt-get update && apt-get install -y wget && wget https://github.com/prysmaticlabs/prysm/releases/latest/download/beacon-chain-linux-amd64 && chmod +x beacon-chain-linux-amd64 && mv beacon-chain-linux-amd64 /usr/local/bin/beacon-chain
                VOLUME ["/data"]
                EXPOSE 4000
                CMD ["beacon-chain", "--mainnet", "--accept-terms-of-use", "--rpc-host", "0.0.0.0", "--rpc-port", "4000"]
                EOF
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                sh """
                docker build -t ${GETH_IMAGE} -f Dockerfile.geth .
                docker build -t ${PRYSM_IMAGE} -f Dockerfile.prysm .
                """
            }
        }

        stage('Update Docker Registry') {
            steps {
                sh """
                docker tag ${GETH_IMAGE} fireblocks/geth-node:latest
                docker tag ${PRYSM_IMAGE} fireblocks/prysm-node:latest
                docker push fireblocks/geth-node:latest
                docker push fireblocks/prysm-node:latest
                """
            }
        }

        stage('Launch Geth & Prysm Containers') {
            steps {
                sh """
                docker run -d --name geth-node --restart unless-stopped \
                    -v ${GETH_DATA_DIR}:/root/.ethereum \
                    -p 30303:30303 -p 30303:30303/udp \
                    -p 8545:8545 -p 8546:8546 -p 8551:8551 \
                    ${GETH_IMAGE}
                
                docker run -d --name prysm-node --restart unless-stopped \
                    -v ${PRYSM_DATA_DIR}:/data \
                    -p 4000:4000 \
                    ${PRYSM_IMAGE}
                """
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
