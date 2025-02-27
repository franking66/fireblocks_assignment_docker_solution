pipeline {
    agent any

    environment {
        GETH_DATA_DIR = "/var/lib/geth"
        PRYSM_DATA_DIR = "/var/lib/prysm"
        ETH_NETWORK = "mainnet"
        GETH_IMAGE = "ethereum/client-go:latest"
        PRYSM_IMAGE = "gcr.io/prysmaticlabs/prysm/beacon-chain:latest"
        NODE_NAME = "fireblocks-eth-node"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/franking66/fireblocks_assignment_docker_solution.git'
            }
        }

        stage('Pull Docker Images') {
            steps {
                sh """
                docker pull ${GETH_IMAGE}
                docker pull ${PRYSM_IMAGE}
                """
            }
        }

        stage('Create Persistent Volumes') {
            steps {
                sh """
                mkdir -p ${GETH_DATA_DIR} ${PRYSM_DATA_DIR}
                chmod -R 777 ${GETH_DATA_DIR} ${PRYSM_DATA_DIR}
                """
            }
        }

        stage('Launch Geth Light Sync Node') {
            steps {
                sh """
                docker run -d --name geth-node --restart unless-stopped \
                    --network=host \
                    -v ${GETH_DATA_DIR}:/root/.ethereum \
                    -p 30303:30303 -p 30303:30303/udp \
                    -p 8545:8545 -p 8551:8551 -p 8546:8546 \
                    ${GETH_IMAGE} \
                    --syncmode light \
                    --http --http.addr "0.0.0.0" --http.port 8545 \
                    --http.api "eth,net,web3,admin" \
                    --ws --ws.addr "0.0.0.0" --ws.port 8546 \
                    --bootnodes "enode://<EthereumFoundationBootNodes>"
                """
            }
        }

        stage('Launch Prysm Validator Node') {
            steps {
                sh """
                docker run -d --name prysm-validator --restart unless-stopped \
                    --network=host \
                    -v ${PRYSM_DATA_DIR}:/data \
                    -p 4000:4000 \
                    ${PRYSM_IMAGE} \
                    --mainnet \
                    --accept-terms-of-use \
                    --rpc-host 0.0.0.0 --rpc-port 4000
                """
            }
        }

        stage('Update Container Registry') {
            steps {
                sh """
                docker images | grep "ethereum\\|prysm"
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
