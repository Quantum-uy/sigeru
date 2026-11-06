# SiGeRU - Manual de instalación (Linux + Docker)

Arquitectura: 3 contenedores en la red `sigeru_net`.

| Contenedor | Imagen | Función |
|---|---|---|
| sigeru_app | php:8.2-apache | Landing, backoffice y 4 APIs (puerto 8080) |
| sigeru_db | mysql:8.0 | Base de datos (volumen `mysql_data`) |
| sigeru_backup | mysql:8.0 | Respaldos `.tar.gz` cada 6 h (volumen `backup_data`) |

## 1. Requisitos

```bash
docker --version
docker-compose --version    # o: docker compose version
```

Si falta Docker: `curl -fsSL https://get.docker.com | sudo sh` y `sudo apt install -y docker-compose`.
En Docker moderno usar `docker compose` (sin guion) en lugar de `docker-compose`.

## 2. Obtener el código

```bash
git clone --recurse-submodules https://github.com/Quantum-uy/sigeru.git
cd sigeru
```

Cada módulo (APIs, backoffice, landing, scripts) es un repositorio propio enlazado como submódulo. Si se clonó sin la opción: `git submodule update --init --recursive`.

El archivo `.env` (credenciales y puerto) viene en el repositorio. Editarlo si se necesita otro puerto.

## 3. Construir y levantar

```bash
sudo docker-compose up -d --build
sudo docker-compose ps
```

Esperar a que `sigeru_db` figure como `healthy`. La estructura y los datos de prueba se cargan solos desde `db/init.sql` la primera vez.

## 4. Verificar

- Landing: `http://IP_SERVIDOR:8080`
- Backoffice: `http://IP_SERVIDOR:8080/frontend-backoffice/login.html`

| Rol | Email | Contraseña |
|---|---|---|
| Administrador | admin@sigeru.uy | admin123 |
| Operario | operario@sigeru.uy | test1234 |
| Conductor | conductor.test@sigeru.uy | test1234 |
| Peón | peon@sigeru.uy | test1234 |

Base de datos (tablas y datos):

```bash
sudo docker exec sigeru_db mysql -usigeru_user -pclave_sigeru sigeru -e "SHOW TABLES; SELECT email FROM usuario;"
```

Comunicación app -> BD: iniciar sesión en el backoffice (la API consulta MySQL por el host `db`).

## 5. Persistencia

```bash
sudo docker-compose down        # sin -v: los volúmenes se conservan
sudo docker-compose up -d
```

Los datos creados desde el backoffice siguen ahí. `down -v` borra los volúmenes (reinicio completo).

## 6. Respaldos (.tar.gz)

El contenedor `sigeru_backup` genera un respaldo cada 6 horas. Para forzar uno:

```bash
sudo docker exec sigeru_backup /usr/local/bin/backup.sh
sudo docker exec sigeru_backup ls -lh /backups
```

Cada archivo `sigeru_FECHA.tar.gz` contiene `sigeru.sql` (dump de MySQL) y `sitio/` (código). El script verifica la integridad con `tar -tzf`. Para revisarlo a mano:

```bash
sudo docker exec sigeru_backup sh -c 'tar -tzf /backups/$(ls -t /backups | head -1) | head'
```

Copiar un respaldo al servidor anfitrión:

```bash
sudo docker cp sigeru_backup:/backups ./respaldos
```

## 7. Comandos útiles

```bash
sudo docker-compose logs db      # logs de un servicio
sudo docker-compose restart app  # reiniciar la app
sudo docker-compose down -v      # borrar todo (incluye datos)
```

Nota (docker-compose 1.29): si aparece `KeyError: 'ContainerConfig'`, ejecutar `docker-compose down` y luego `up -d --build`.
