pipeline {
    agent any
    
    environment {
        // Server details
        SERVER_HOST = '20.73.154.112'
        SERVER_USER = 'useradmin'
        DEPLOYMENT_DIR = '/opt/microservices'  // Directorio donde Ansible desplegó los archivos
        
        // Docker Hub credentials
        DOCKER_HUB_USERNAME = credentials('DOCKER_HUB_USERNAME') 
        DOCKER_HUB_TOKEN = credentials('DOCKER_HUB_TOKEN')
        
        // VM password
        VM_PASSWORD = credentials('AZURE_VM_PASSWORD')
    }
    
    stages {
        stage('Connect to Server') {
            steps {
                script {
                    sh '''
                        if ! command -v sshpass &> /dev/null; then
                            echo "sshpass no está instalado. Intentando instalarlo..."
                            sudo apt-get update && sudo apt-get install -y sshpass || true
                        fi
                    '''
                    
                    sh """
                        sshpass -p '${VM_PASSWORD}' ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} 'echo Connection successful'
                    """
                }
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    sh """
                        sshpass -p '${VM_PASSWORD}' ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} '
                            echo ${DOCKER_HUB_TOKEN} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
                        '
                    """
                }
            }
        }
        
        stage('Pull Latest Images') {
            steps {
                script {
                    sh """
                        sshpass -p '${VM_PASSWORD}' ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} '
                            # Pull the latest images from Docker Hub
                            docker pull ${DOCKER_HUB_USERNAME}/auth-api:latest
                            docker pull ${DOCKER_HUB_USERNAME}/frontend:latest
                            docker pull ${DOCKER_HUB_USERNAME}/log-message-processor:latest
                            docker pull ${DOCKER_HUB_USERNAME}/todos-api:latest
                            docker pull ${DOCKER_HUB_USERNAME}/users-api:latest
                        '
                    """
                }
            }
        }
        
        stage('Update docker-compose.yml') {
            steps {
                script {
                    // Verificamos si existe el script update-compose.sh, si no, lo creamos
                    sh """
                        sshpass -p '${VM_PASSWORD}' ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} '
                            cd ${DEPLOYMENT_DIR}
                            if [ ! -f update-compose.sh ]; then
                                cat > update-compose.sh << 'EOF'
#!/bin/bash
DOCKER_USERNAME="${DOCKER_HUB_USERNAME}"
cp docker-compose.yml docker-compose.yml.bak
sed -i "s|build: ./auth-api|image: ${DOCKER_USERNAME}/auth-api:latest|g" docker-compose.yml
sed -i "s|build: ./frontend|image: ${DOCKER_USERNAME}/frontend:latest|g" docker-compose.yml
sed -i "s|build: ./log-message-processor|image: ${DOCKER_USERNAME}/log-message-processor:latest|g" docker-compose.yml
sed -i "s|build: ./todos-api|image: ${DOCKER_USERNAME}/todos-api:latest|g" docker-compose.yml
sed -i "s|build: ./users-api|image: ${DOCKER_USERNAME}/users-api:latest|g" docker-compose.yml
EOF
                                chmod +x update-compose.sh
                            fi
                            
                            # Ejecutar el script para actualizar docker-compose.yml
                            chmod +x ./update-compose.sh
                            ./update-compose.sh
                        '
                    """
                }
            }
        }
        
        stage('Reload Services') {
            steps {
                script {
                    sh """
                        sshpass -p '${VM_PASSWORD}' ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} '
                            cd ${DEPLOYMENT_DIR}
                            
                            # Recrear solo los contenedores necesarios sin perder datos
                            docker-compose up -d --no-deps --force-recreate auth-api frontend log-message-processor todos-api users-api
                        '
                    """
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sh """
                        sshpass -p '${VM_PASSWORD}' ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} '
                            # Wait for services to be fully up
                            sleep 20
                            
                            # Check if all services are running
                            cd ${DEPLOYMENT_DIR}
                            SERVICES_DOWN=\$(docker-compose ps --services --filter "status=stopped" | wc -l)
                            
                            if [ \$SERVICES_DOWN -gt 0 ]; then
                                echo "Error: Some services failed to start!"
                                docker-compose ps
                                exit 1
                            else
                                echo "All services are running!"
                                docker-compose ps
                            fi
                        '
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}