# Inventory App

Flutter project for an inventory app that will primarily be used to keep track of freezer inventory.

## Running the Appwrite server

You must have [Docker CLI](https://www.docker.com/products/docker-desktop/) installed to run the appwrite server.  
Appwrite requires [Docker Compose Version 2](https://docs.docker.com/compose/install/). To install Appwrite, make sure your Docker installation is updated to support Composer V2.

### Starting the Appwrite server

In the [appwrite directory](/appwrite), run the following command:
```bash
docker compose up -d --remove-orphans
```

### Stopping the Appwrite server

In the [appwrite directory](/appwrite), run the following command:
```bash
docker compose stop
```

### Uninstalling the Appwrite server

In the [appwrite directory](/appwrite), run the following command:
```bash
docker compose down -v
```