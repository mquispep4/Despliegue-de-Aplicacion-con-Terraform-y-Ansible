# Despliegue-de-Aplicacion-con-Terraform-y-Ansible
# Guía de comandos básicos

## 1. Terraform

Ingresar al directorio inicializar y validar

# Inicializar Terraform
terraform init

# Comprobar formato
terraform fmt -check

# Validar configuración
terraform validate

Para planificar y desplegar infraestructura


# Visualizar los cambios que realizará Terraform
terraform plan

# Utilizar archivo de variables
terraform plan -var-file="terraform.tfvars"

# Aplicar cambios de infraestructura
terraform apply

# Aplicar sin confirmación interactiva
terraform apply -auto-approve

# Aplicar utilizando variables
terraform apply -var-file="terraform.tfvars"

### Consultar infraestructura

# Mostrar estado actual
terraform show

# Listar recursos administrados
terraform state list

# Consultar salidas
terraform output

### Destruir infraestructura

# Eliminar infraestructura
terraform destroy

# Eliminar sin confirmación
terraform destroy -auto-approve

## 2. Ansible

Ingresar al directorio y instalar Ansible

# Actualizar paquetes
sudo apt update

# Instalar Ansible
sudo apt install ansible -y

### Verificar instalación

ansible --version
ansible-playbook --version

### Configurar inventario

# Listar inventario
ansible-inventory -i inventory --list

# Mostrar servidores registrados
ansible springboot -i inventory --list-hosts

### Configurar llave SSH

# Configurar permisos de llave privada
chmod 400 /ruta/llave.pem

# Conectarse a un servidor mediante SSH
ssh -i /ruta/llave.pem ubuntu@IP_PUBLICA

### Probar conexión

# Comprobar conexión con los servidores
ansible springboot -i inventory -m ping

### Ejecutar comandos remotos

# Consultar nombre del servidor
ansible springboot -i inventory -m command -a "hostname"

# Consultar versión de Python
ansible springboot -i inventory -m command -a "python3 --version"

# Consultar memoria
ansible springboot -i inventory -m command -a "free -h"

# Consultar espacio de disco
ansible springboot -i inventory -m command -a "df -h"

### Validar y ejecutar Playbook

# Validar sintaxis
ansible-playbook -i inventory playbook.yml --syntax-check

# Simular ejecución
ansible-playbook -i inventory playbook.yml --check

# Ejecutar Playbook
ansible-playbook -i inventory playbook.yml

# Ejecutar mostrando detalles
ansible-playbook -i inventory playbook.yml -v

# Ejecutar con máximo detalle
ansible-playbook -i inventory playbook.yml -vvv

# Ejecutar con privilegios administrativos
ansible-playbook -i inventory playbook.yml --become

# Ejecutar en un servidor específico
ansible-playbook -i inventory playbook.yml --limit IP_PUBLICA


## 3. Jenkins

### Verificar Java

java -version

### Administrar servicio Jenkins 

# Consultar estado
sudo systemctl status jenkins

# Iniciar Jenkins
sudo systemctl start jenkins

# Detener Jenkins
sudo systemctl stop jenkins

# Reiniciar Jenkins
sudo systemctl restart jenkins

# Habilitar inicio automático
sudo systemctl enable jenkins

# Consultar registros
sudo journalctl -u jenkins -f

### Obtener contraseña inicial

sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Acceder a Jenkins
http://localhost:8080

### Validar Jenkinsfile

curl -X POST \
  -F "jenkinsfile=<Jenkinsfile" \
  http://localhost:8080/pipeline-model-converter/validate


### Ejecutar Pipeline

 Ingresar a Jenkins.
 Crear un proyecto de tipo Pipeline.
 Configurar el repositorio Git.
 Seleccionar la rama del proyecto.
 Especificar la ruta del Jenkinsfile.
 Guardar la configuración.
 Seleccionar **Build Now** para ejecutar el Pipeline.
-

## 4. Orden general de ejecución

1.- cd project/terraform

2.- terraform init

3.- terraform fmt

4.- terraform validate

5.- terraform plan

6.- terraform apply

7.- cd ../ansible

8.- ansible springboot -i inventory -m ping

9.- ansible-playbook -i inventory playbook.yml --syntax-check

10.- ansible-playbook -i inventory playbook.yml

