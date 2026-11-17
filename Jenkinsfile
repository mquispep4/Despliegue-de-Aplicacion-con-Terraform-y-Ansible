
pipeline {
    agent any

    tools {
        terraform 'Terraform_1_16'
        jdk 'jdk21'
    }

    parameters {
        booleanParam(
            name: 'DESTROY_INFRA',
            defaultValue: false,
            description: 'Destruir la infraestructura AWS al finalizar'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Compilacion y Tests') {
            steps {
                dir('app') {
                    sh '''
                        chmod +x mvnw
                        ./mvnw clean package
                        
                        JAR=$(find target -maxdepth 1 -type f \
                          -name "*.jar" ! -name "original-*" \
                          | head -n 1)

                        test -n "$JAR"
                        cp "$JAR" target/app.jar
                    '''
                }
            }

            post {
                success {
                    echo 'Compilacion y pruebas exitosas.'
                }
                failure {
                    error('Fallaron las pruebas. Pipeline detenido.')
                }
            }
        }

        stage('Guardar artefacto JAR') {
            steps {
                archiveArtifacts(
                    artifacts: 'app/target/app.jar',
                    fingerprint: true
                )
            }
        }

        stage('Terraform Init y Validate') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform fmt -check
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan y Apply') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials'
                    ]
                ]) {
                    dir('terraform') {
                        sh '''
                            terraform plan -out=tfplan
                            terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Obtener IP publica EC2') {
            steps {
                script {
                    dir('terraform') {
                        env.EC2_PUBLIC_IP = sh(
                            script: 'terraform output -raw ip_para_springboot',
                            returnStdout: true
                        ).trim()
                    }

                    echo "IP publica EC2: ${env.EC2_PUBLIC_IP}"

                    writeFile(
                        file: 'ansible/inventory',
                        text: """[springboot]
${env.EC2_PUBLIC_IP}

[springboot:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3
"""
                    )
                }
            }
        }

        stage('Deploy con Ansible') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'clasesdevops-pem',
                        variable: 'AWS_KEY_FILE'
                    )
                ]) {
                    sh '''
                        chmod 600 "$AWS_KEY_FILE"

                        ansible springboot \
                            -i ansible/inventory \
                            --private-key "$AWS_KEY_FILE" \
                            -m ping

                        ansible-playbook \
                            -i ansible/inventory \
                            --private-key "$AWS_KEY_FILE" \
                            ansible/playbook.yml
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    params.DESTROY_INFRA
                }
            }

            steps {
                input message: '¿Confirmas destruir la infraestructura AWS?'

                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials'
                    ]
                ]) {
                    dir('terraform') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completado correctamente.'
        }

        failure {
            echo 'Error durante la ejecucion del pipeline.'
        }
    }
}
