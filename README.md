# Как работать с репозиторием финального задания

## Что нужно сделать

Настроить запуск проекта Kittygram в контейнерах, создать виртуальную
инфраструктуру в Yandex Cloud с помощью Terraform и выполнить деплой через
GitHub Actions.

## Инфраструктура Terraform

Terraform-конфигурация лежит в директории `infra/` и создаёт:

- VPC network и subnet;
- Security Group с входящими портами `22` и `9000`;
- VM на Ubuntu 24.04 LTS;
- cloud-init установку Docker и Docker Compose plugin;
- output `vm_public_ip`.

Terraform state хранится в заранее созданном S3-бакете Yandex Object Storage.
Имя бакета и ключи доступа передаются через GitHub Secrets, в репозиторий они
не записываются.

Ручной запуск workflow:

1. Откройте GitHub Actions.
2. Запустите workflow `Terraform`.
3. Выберите `plan`, `apply` или `destroy`.

После успешного `apply` возьмите IP из шага `Terraform output`, добавьте его в
GitHub Secret `HOST` и обновите `tests.yml`:

```yaml
repo_owner: norammoranos
kittygram_domain: http://<vm-public-ip>:9000
dockerhub_username: noranori
```

## GitHub Secrets и Variables

Для Terraform workflow нужны:

- `YC_CLOUD_ID` — cloud ID;
- `YC_FOLDER_ID` — folder ID;
- `YC_SERVICE_ACCOUNT_KEY_JSON` — JSON-ключ сервисного аккаунта;
- `YC_STORAGE_ACCESS_KEY` — static access key для Object Storage;
- `YC_STORAGE_SECRET_KEY` — static secret key для Object Storage;
- `TF_STATE_BUCKET` — имя заранее созданного S3-бакета для Terraform state;
- `VM_SSH_PUBLIC_KEY` — публичный SSH-ключ для доступа к VM.

Для deploy workflow нужны:

- `DOCKER_USERNAME`;
- `DOCKER_PASSWORD`;
- `HOST` — публичный IP VM после `terraform apply`;
- `USER` — пользователь VM, по умолчанию `yc-user`;
- `SSH_KEY` — приватный SSH-ключ для доступа к VM;
- `SSH_PASSPHRASE` — passphrase, если ключ защищён;
- `POSTGRES_DB`;
- `POSTGRES_USER`;
- `POSTGRES_PASSWORD`;
- `SECRET_KEY`;
- `TELEGRAM_TO`;
- `TELEGRAM_TOKEN`.

Опционально для создания администратора Django:

- `DJANGO_SUPERUSER_USERNAME`;
- `DJANGO_SUPERUSER_EMAIL`;
- `DJANGO_SUPERUSER_PASSWORD`.

GitHub variable:

- `YC_ZONE` — зона Yandex Cloud, по умолчанию используется `ru-central1-a`.

## Как проверить работу с помощью автотестов

В корне репозитория создайте файл tests.yml со следующим содержимым:
```yaml
repo_owner: ваш_логин_на_гитхабе
kittygram_domain: полная ссылка (http://<ip-адрес вашей ВМ>:<порт gateway>) на ваш проект Kittygram
dockerhub_username: ваш_логин_на_докерхабе
```

Скопируйте содержимое файла `.github/workflows/deploy.yml` в файл
`kittygram_workflow.yml` в корневой директории проекта.

Для локального запуска тестов создайте виртуальное окружение, установите в него зависимости из backend/requirements.txt и запустите в корневой директории проекта `pytest`.

## Чек-лист для проверки перед отправкой задания

- Проект Kittygram доступен по ссылке, указанной в `tests.yml`.
- Workflow `Terraform` вручную создаёт инфраструктуру.
- Пуш в ветку main запускает тестирование и деплой Kittygram, а после успешного деплоя вам приходит сообщение в телеграм.
- В корне проекта есть файл `kittygram_workflow.yml`.
- В `.github/workflows/` есть `terraform.yml` и `deploy.yml`.
