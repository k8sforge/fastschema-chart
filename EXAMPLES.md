# FastSchema Chart - Usage Examples

This document provides practical examples for using the FastSchema Helm chart.

## Basic Installation

```bash
helm install fastschema ./charts/fastschema
```

## High Availability Configuration

```yaml
# values-ha.yaml
replicaCount: 3

podDisruptionBudget:
  enabled: true
  minAvailable: 2

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - fastschema
          topologyKey: kubernetes.io/hostname

database:
  driver: "pgx"
  name: "fastschema"
  host: "postgres.example.com"
  port: "5432"
  user: "fastschema"
  existingSecret: "postgres-secret"
  existingSecretPasswordKey: "password"
```

```bash
helm install fastschema ./charts/fastschema -f values-ha.yaml
```

## Database Configuration

### SQLite (Default)

```yaml
# values-sqlite.yaml
database:
  driver: "sqlite"
```

### MySQL

```yaml
# values-mysql.yaml
database:
  driver: "mysql"
  name: "fastschema"
  host: "mysql.example.com"
  port: "3306"
  user: "fastschema"
  existingSecret: "mysql-secret"
  existingSecretPasswordKey: "password"
```

### PostgreSQL

```yaml
# values-postgres.yaml
database:
  driver: "pgx"
  name: "fastschema"
  host: "postgres.example.com"
  port: "5432"
  user: "fastschema"
  existingSecret: "postgres-secret"
  existingSecretPasswordKey: "password"
```

## Auth Provider Configuration

### Local Auth Only

```yaml
# values-auth-local.yaml
auth:
  enabled: true
  enabledProviders:
    - "local"
  providers:
    local:
      activation_method: "email"
      activation_url: "https://myapp.com/activation"
      recovery_url: "https://myapp.com/recover"
```

### GitHub OAuth

```yaml
# values-auth-github.yaml
auth:
  enabled: true
  enabledProviders:
    - "local"
    - "github"
  providers:
    local:
      activation_method: "email"
      activation_url: "https://myapp.com/activation"
      recovery_url: "https://myapp.com/recover"
    github:
      client_id: "your-github-client-id"
      client_secret: "your-github-client-secret"
```

### Multiple OAuth Providers

```yaml
# values-auth-multi.yaml
auth:
  enabled: true
  enabledProviders:
    - "local"
    - "github"
    - "google"
    - "twitter"
  providers:
    local:
      activation_method: "email"
      activation_url: "https://myapp.com/activation"
      recovery_url: "https://myapp.com/recover"
    github:
      client_id: "your-github-client-id"
      client_secret: "your-github-client-secret"
    google:
      client_id: "your-google-client-id"
      client_secret: "your-google-client-secret"
    twitter:
      consumer_key: "your-twitter-consumer-key"
      consumer_secret: "your-twitter-consumer-secret"
```

## Storage Configuration

### Local Storage

```yaml
# values-storage-local.yaml
storage:
  defaultDisk: "public"
  disks:
    - name: "public"
      driver: "local"
      root: "./public"
      public_path: "/files"
      base_url: "https://myapp.com/files"
```

### S3 Storage

```yaml
# values-storage-s3.yaml
storage:
  defaultDisk: "s3"
  disks:
    - name: "public"
      driver: "local"
      root: "./public"
      public_path: "/files"
      base_url: "https://myapp.com/files"
    - name: "s3"
      driver: "s3"
      provider: "aws"
      endpoint: "s3.amazonaws.com"
      region: "us-east-1"
      bucket: "my-bucket"
      access_key_id: "your-access-key"
      secret_access_key: "your-secret-key"
      acl: "public-read"
```

## Mail Configuration

```yaml
# values-mail.yaml
mail:
  senderName: "FastSchema Accounts"
  senderMail: "accounts@myapp.com"
  defaultClient: "smtp"
  clients:
    - name: "smtp"
      driver: "smtp"
      host: "smtp.example.com"
      port: 587
      username: "user@example.com"
      password: "password"
```

## ServiceMonitor for Prometheus

```yaml
# values-monitoring.yaml
monitoring:
  serviceMonitor:
    enabled: true
    interval: "30s"
    labels:
      release: prometheus
```

```bash
helm install fastschema ./charts/fastschema -f values-monitoring.yaml
```

## Custom Resource Limits

```yaml
# values-resources.yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "1000m"
```

## Complete Example

```yaml
# values-complete.yaml
replicaCount: 3

podDisruptionBudget:
  enabled: true
  minAvailable: 2

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - fastschema
          topologyKey: kubernetes.io/hostname

resources:
  requests:
    memory: "512Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "1000m"

appBaseUrl: "https://myapp.com"
appDashUrl: "https://myapp.com/dash"

database:
  driver: "pgx"
  name: "fastschema"
  host: "postgres.example.com"
  port: "5432"
  user: "fastschema"
  existingSecret: "postgres-secret"
  existingSecretPasswordKey: "password"

auth:
  enabled: true
  enabledProviders:
    - "local"
    - "github"
    - "google"
  providers:
    local:
      activation_method: "email"
      activation_url: "https://myapp.com/activation"
      recovery_url: "https://myapp.com/recover"
    github:
      client_id: "your-github-client-id"
      client_secret: "your-github-client-secret"
    google:
      client_id: "your-google-client-id"
      client_secret: "your-google-client-secret"

storage:
  defaultDisk: "s3"
  disks:
    - name: "s3"
      driver: "s3"
      provider: "aws"
      endpoint: "s3.amazonaws.com"
      region: "us-east-1"
      bucket: "my-bucket"
      access_key_id: "your-access-key"
      secret_access_key: "your-secret-key"
      acl: "public-read"

mail:
  senderName: "FastSchema Accounts"
  senderMail: "accounts@myapp.com"
  defaultClient: "smtp"
  clients:
    - name: "smtp"
      driver: "smtp"
      host: "smtp.example.com"
      port: 587
      username: "user@example.com"
      password: "password"

persistence:
  enabled: true
  storageClassName: "gp3"
  size: "50Gi"

monitoring:
  serviceMonitor:
    enabled: true
    interval: "30s"
    labels:
      release: prometheus
```

```bash
helm install fastschema ./charts/fastschema -f values-complete.yaml
```
