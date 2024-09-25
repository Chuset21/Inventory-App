# Inventory App

Flutter project for an inventory app that will primarily be used to keep track of freezer inventory.

## Before running the flutter app

Before running the flutter app, auto generate the necessary files by running:

```bash
dart run build_runner build
```

## Running the Appwrite server

You must have [Docker CLI](https://www.docker.com/products/docker-desktop/) installed to run the
appwrite server.  
Appwrite requires [Docker Compose Version 2](https://docs.docker.com/compose/install/). To install
Appwrite, make sure your Docker installation is updated to support Composer V2.

### Loading appwrite configuration into flutter environment

In the root directory you should have a `.env` file, which should look something like this:

```dotenv
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=66f13293002880cf645e
DATABASE_ID=67f13293002850cf623a
COLLECTION_ID=68g53293002880cf1e8b
```

If you change the key names, make sure to change the key names
in [constants/env.dart](/lib/core/constants/env.dart).

You can also change the configuration settings in the settings page.  
**Note that the configuration settings are treated as case insensitive and will be converted to
lowercase.**

### Starting the Appwrite server

In the [appwrite directory](/appwrite), run the following command:

```bash
docker compose up --remove-orphans
```

**Note**: If you would prefer to run this service in the background, use:

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

## App Signing

To sign the app for release mode you must have a keystore file and a file in [/android](/android)
called `key.properties`.
It should look something like this.

```properties
storePassword=abc123
keyPassword=abc123
keyAlias=upload
storeFile=<keystore-file-location>
```

Since the keystore file and the `key.properties` file contain sensitive and personal information I
have not checked them into the repository.