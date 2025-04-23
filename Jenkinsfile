pipeline {
    agent any
    
    environment {
        // Server details
        SERVER_HOST = '20.73.154.112'
        SERVER_USER = 'useradmin'
        DEPLOYMENT_DIR = '/opt/microservices'  // Directorio donde Ansible desplegó los archivos
        
        // Docker Hub credentials
        DOCKER_HUB = credentials('DOCKER_HUB_CREDENTIALS')
        
        // VM password
        VM_PASSWORD = credentials('AZURE_VM_PASSWORD')
        
        // SonarQube credentials
        SONAR_HOST_URL = credentials('SONAR_HOST_URL')
        SONAR_TOKEN = credentials('SONAR_TOKEN')
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
                        sshpass -p 'Password@123' ssh -o StrictHostKeyChecking=no adminuser@20.73.154.112 'echo Connection successful'
                    """
                }
            }
        }
        
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             // Configurar SonarQube Scanner
        //             def scannerHome = tool 'SonarQubeScanner'
        //             withSonarQubeEnv('SonarQube') {
        //                 sh """
        //                     ${scannerHome}/bin/sonar-scanner \
        //                     -Dsonar.projectKey=microservice-app-example \
        //                     -Dsonar.sources=./ \
        //                     -Dsonar.host.url=${SONAR_HOST_URL} \
        //                     -Dsonar.login=${SONAR_TOKEN} \
        //                     -Dsonar.exclusions=**/test/**,**/node_modules/**,**/build/**,**/target/** \
        //                     -Dsonar.qualitygate.wait=false
        //                 """
        //             }
        //         }
        //     }
        // }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    sh """
                        sshpass -p 'Password@123' ssh -o StrictHostKeyChecking=no adminuser@20.73.154.112 '
                            echo ${DOCKER_HUB_PSW} | docker login -u ${DOCKER_HUB_USR} --password-stdin
                        '
                    """
                }
            }
        }
        
        stage('Pull Latest Images') {
            steps {
                script {
                    sh """
                        sshpass -p 'Password@123' ssh -o StrictHostKeyChecking=no adminuser@20.73.154.112 '
                            # Pull the latest images from Docker Hub
                            docker pull ${DOCKER_HUB_USR}/auth-api:latest
                            docker pull ${DOCKER_HUB_USR}/frontend:latest
                            docker pull ${DOCKER_HUB_USR}/log-message-processor:latest
                            docker pull ${DOCKER_HUB_USR}/todos-api:latest
                            docker pull ${DOCKER_HUB_USR}/users-api:latest
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
                        sshpass -p 'Password@123' ssh -o StrictHostKeyChecking=no adminuser@20.73.154.112 '
                            cd ${DEPLOYMENT_DIR}
                            if [ ! -f update-compose.sh ]; then
                                cat > update-compose.sh << 'EOF'
#!/bin/bash
cp docker-compose.yml docker-compose.yml.bak
sed -i "s|build: ./auth-api|image: ${DOCKER_HUB_USR}/auth-api:latest|g" docker-compose.yml
sed -i "s|build: ./frontend|image: ${DOCKER_HUB_USR}/frontend:latest|g" docker-compose.yml
sed -i "s|build: ./log-message-processor|image: ${DOCKER_HUB_USR}/log-message-processor:latest|g" docker-compose.yml
sed -i "s|build: ./todos-api|image: ${DOCKER_HUB_USR}/todos-api:latest|g" docker-compose.yml
sed -i "s|build: ./users-api|image: ${DOCKER_HUB_USR}/users-api:latest|g" docker-compose.yml
EOF
                        fi

                            
                            # Ejecutar el script para actualizar docker-compose.yml
                            sudo chmod +x ./update-compose.sh
                            sudo ./update-compose.sh
                        '
                    """
                }
            }
        }
        
        stage('Reload Services') {
            steps {
                script {
                    sh """
                        sshpass -p 'Password@123' ssh -o StrictHostKeyChecking=no adminuser@20.73.154.112 '
                            cd ${DEPLOYMENT_DIR}
                            
                            # Recrear solo los contenedores necesarios sin perder datos
                            sudo docker-compose up -d --no-deps --force-recreate auth-api frontend log-message-processor todos-api users-api
                        '
                    """
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    sh """
                        sshpass -p 'Password@123' ssh -o StrictHostKeyChecking=no adminuser@20.73.154.112 '
                            # Wait for services to be fully up
                            sleep 20
                            
                            # Check if all services are running
                            cd ${DEPLOYMENT_DIR}
                            SERVICES_DOWN=\$(docker-compose ps --services --filter "status=stopped" | wc -l)
                            
                            if [ \$SERVICES_DOWN -gt 1 ]; then
                                echo "Error: Some services failed to start!"
                                sudo docker-compose ps
                                exit 1
                            else
                                echo "All services are running!"
                                sudo docker-compose ps
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