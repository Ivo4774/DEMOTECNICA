# DEMOTECNICA
# Prueba Técnica DevOps: Integración HL7 y FHIR

Este repositorio contiene la solución a la prueba técnica para el perfil DevOps. El proyecto implementa una Prueba de Concepto (POC) que orquesta la recepción de mensajes HL7 v2.x, su almacenamiento en base de datos y su transformación a recursos FHIR.

La solución se encuentra containerizada utilizando **Docker Compose** e integra los servicios de **Mirth Connect**, **PostgreSQL** y **HAPI FHIR Server**.

## 📋 Contenido del Repositorio

* **`docker-compose.yml`**: Definición de la infraestructura, redes y volúmenes.
* **`init.sql`**: Script de inicialización de la base de datos (`hl7_raw_messages`).
* **`HL7_POC.xml`**: Configuración exportada del canal de integración de Mirth Connect.

## 🚀 Despliegue y Ejecución

### Prerrequisitos
* Docker Desktop (o Docker Engine + Compose) instalado y corriendo.
* Git.

### Instrucciones de Despliegue

1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/tu-usuario/PruebaTecnica.git](https://github.com/tu-usuario/PruebaTecnica.git)
    cd PruebaTecnica
    ```

2.  **Iniciar la plataforma:**
    Ejecutar el siguiente comando para levantar la infraestructura en segundo plano:
    ```bash
    docker compose up -d
    ```
    *Nota: El servicio de Mirth Connect puede demorar unos minutos en estar completamente operativo durante el primer arranque mientras inicializa su esquema de base de datos interna.*

3.  **Verificar estado:**
    Asegurarse de que los contenedores estén sanos (`healthy`) o corriendo (`started`):
    ```bash
    docker compose ps
    ```

## ⚙️ Endpoints y Credenciales

A continuación se detallan los accesos, puertos y credenciales por defecto configurados en el `docker-compose.yml`:

| Servicio | URL / Host | Puerto Externo | Usuario | Contraseña |
| :--- | :--- | :--- | :--- | :--- |
| **Mirth Connect (UI)** | `http://localhost` | `8080` / `8443` | `admin` | `admin` |
| **PostgreSQL** | `localhost` | `5432` | `admin` | `admin123` |
| **HAPI FHIR Server** | `http://localhost` | `8090` | N/A | N/A |
| **HL7 Listener (TCP)** | `localhost` | `6661` | N/A | N/A |

* **Base de Datos de Negocio:** `hl7db`
* **Tabla de persistencia:** `hl7_raw_messages`

## 🧪 Ejecución y Prueba de Envío

### 1. Enviar Mensaje HL7
Para probar el flujo de integración, enviar el siguiente mensaje **ADT^A01** al puerto TCP **6661**. Se puede realizar mediante la herramienta "Send Message" del Dashboard de Mirth o utilizando un cliente TCP (como Netcat).

**Mensaje de prueba:**
*(Importante: Respetar el salto de línea entre segmentos)*

```text
MSH|^~\&|HIS|RIH|EKG|EKG|200202150930||ADT^A01|MSG00001|P|2.3
PID|1||123456||PEREZ^JUAN
### 2. Validaciones

#### A. Verificación en PostgreSQL
Conectarse a la base de datos con las credenciales provistas y verificar que el mensaje crudo se haya insertado:

```sql
SELECT * FROM hl7_raw_messages ORDER BY id DESC;
#### B. Verificación en HAPI FHIR
Confirmar que el recurso ha sido transformado y creado en el servidor FHIR consultando el siguiente endpoint en el navegador o Postman:

* **GET:** `http://localhost:8090/fhir/Patient`
* **Resultado esperado:** Un JSON Bundle conteniendo el recurso `Patient` con ID `123456` y nombre `JUAN PEREZ`.

##  Comandos Necesarios para Correr la POC

Resumen de comandos útiles para la gestión del ciclo de vida de la prueba:

* **Iniciar entorno:**
  ```bash
  docker compose up -d
  docker logs -f mirth_connect
  docker compose restart
  docker compose down -v