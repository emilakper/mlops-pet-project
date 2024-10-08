# MLOps Инфраструктура: Автоматизация развертывания PostgreSQL на GPU и Airflow для запуска DAG'ов в облаке с использованием Terraform и Ansible"

Данный пет-проект включает в себя:

- [x] Автоматизацию развертывания виртуальных машин с Linux и GPU-серверов в облаке провайдера Selectel с использованием Terraform.

- [ ] Ansible-плейбуки и роли для автоматизации развертывания и конфигурации систем PostgreSQL и Airflow.

## Содержание

- [Требования](#требования)
- [Структура проекта](#структура-проекта)
- [Конфигурация](#конфигурация)
- [Использование](#использование)
- [Выходные данные](#выходные-данные)

## Требования

Перед началом работы убедитесь, что у вас есть следующее:

- Установленный [Terraform](https://www.terraform.io/downloads.html) на вашем локальном компьютере.
- Учетная запись Selectel с необходимыми правами.
- Пара ключей SSH для доступа к инстансам.

## Структура проекта

Проект имеет следующую структуру:

```
.
├── README.md
├── .gitignore
└── terraform
    ├── variables.tf
    ├── providers.tf
    ├── project.tf
    ├── network.tf
    ├── compute.tf
    ├── outputs.tf
    └── terraform.tfvars (опционально)
```
- `variables.tf`: Определяет все переменные, используемые в проекте.
- `providers.tf`: Настраивает провайдеры Selectel и OpenStack.
- `project.tf`: Определяет проект Selectel и сервисного пользователя.
- `network.tf`: Определяет сетевые ресурсы.
- `compute.tf`: Определяет вычислительные ресурсы.
- `outputs.tf`: Определяет выходные данные.
- `terraform.tfvars`: (Опционально) Файл для хранения значений переменных.

## Конфигурация

1. **Создайте файл `terraform.tfvars`** (опционально):
   Вы можете создать файл `terraform.tfvars` для хранения значений переменных.

   ```
   selectel_domain_name = "your_domain_name"
   selectel_username    = "your_username"
   selectel_password    = "your_password"
   project_name         = "your_project_name"
   service_username     = "your_service_username"
   password             = "your_service_password"
   private_subnet_cidr  = "your_subnet_cidr"
   vcpus                = 2
   ram                  = 2048
   disk_size            = 5
   gpu                  = 2
   ```

2. **Настройте переменные окружения**:
   Если вы предпочитаете, можно определить необходимые переменные окружения для учетных данных Selectel через переменные CLI.

   ```sh
   export TF_VAR_selectel_domain_name="your_domain_name"
   export TF_VAR_selectel_username="your_username"
   export TF_VAR_selectel_password="your_password"
   export TF_VAR_project_name="your_project_name"
   export TF_VAR_service_username="your_service_username"
   export TF_VAR_password="your_service_password"
   export TF_VAR_private_subnet_cidr="your_subnet_cidr"
   export TF_VAR_vcpus=2
   export TF_VAR_ram=2048
   export TF_VAR_disk_size=5
   export TF_VAR_gpu=2
   ```

## Использование

1. **Перейдите в директорию с конфигурациями Terraform**:
   Запустите следующую команду для перехода в директорию.

   ```sh
   cd terraform
   ```

2. **Инициализируйте Terraform**:
   Запустите следующую команду для инициализации Terraform и загрузки необходимых провайдеров.

   ```sh
   terraform init
   ```

3. **Планирование развертывания**:
   Запустите следующую команду, чтобы увидеть, какие изменения Terraform внесет.

   ```sh
   terraform plan
   ```

4. **Примените развертывание**:
   Запустите следующую команду для применения изменений и создания ресурсов.

   ```sh
   terraform apply
   ```

5. **Удалите развертывание** (при необходимости):
   Запустите следующую команду для удаления ресурсов, созданных Terraform.

   ```sh
   terraform destroy
   ```

## Выходные данные

После развертывания Terraform выведет публичный IP-адрес созданного инстанса. Вы можете найти это в файле `outputs.tf`.

```hcl
output "public_ip_address" {
  value = openstack_networking_floatingip_v2.floatingip_1.address
}
```
