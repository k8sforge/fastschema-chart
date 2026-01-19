# FastSchema Chart

A Helm chart for FastSchema with HA defaults, resource management, and comprehensive configuration.

This chart provides a deployment of [FastSchema](https://fastschema.com/).

## Features

- **High Availability**: Configurable replicas, PodDisruptionBudget, and anti-affinity rules
- **Resource Management**: Sensible default resource requests and limits
- **Health Checks**: Pre-configured liveness and readiness probes
- **Database Support**: SQLite (default), MySQL, and PostgreSQL
- **Auth Providers**: Local, GitHub, Google, and Twitter OAuth support
- **Storage Configuration**: Local and S3-compatible storage backends
- **Mail Configuration**: Multiple SMTP client support
- **ServiceMonitor**: Optional Prometheus ServiceMonitor for metrics scraping
- **Platform Agnostic**: No AWS-specific code (Terraform handles ALB, Cognito, etc.)

## Quick Start

```bash
# Add the repository (when published)
helm repo add k8sforge https://k8sforge.github.io/fastschema-chart
helm repo update

# Install with default values
helm install fastschema k8sforge/fastschema
```

Or install from local chart:

```bash
helm install fastschema ./charts/fastschema
```

## Configuration

### High Availability

For HA deployments, configure multiple replicas with PodDisruptionBudget:

```yaml
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
```

**Note**: For HA, use external database (MySQL/PostgreSQL), not SQLite.

### Database Configuration

#### SQLite (Default)

```yaml
database:
  driver: "sqlite"
```

#### MySQL

```yaml
database:
  driver: "mysql"
  name: "fastschema"
  host: "mysql.example.com"
  port: "3306"
  user: "fastschema"
  existingSecret: "mysql-secret"
  existingSecretPasswordKey: "password"
```

#### PostgreSQL

```yaml
database:
  driver: "pgx"
  name: "fastschema"
  host: "postgres.example.com"
  port: "5432"
  user: "fastschema"
  existingSecret: "postgres-secret"
  existingSecretPasswordKey: "password"
```

### Auth Configuration

Enable OAuth providers (GitHub, Google, Twitter):

```yaml
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
```

### Storage Configuration

Configure storage backends (local or S3-compatible):

```yaml
storage:
  defaultDisk: "public"
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
```

### Mail Configuration

Configure SMTP clients:

```yaml
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

### Resource Management

Default resources can be customized:

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "100m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### ServiceMonitor (Prometheus)

Enable Prometheus ServiceMonitor for metrics scraping:

```yaml
monitoring:
  serviceMonitor:
    enabled: true
    interval: "30s"
    labels:
      release: prometheus
```

## Values Reference

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of FastSchema replicas | `1` |
| `podDisruptionBudget.enabled` | Enable PodDisruptionBudget | `false` |
| `podDisruptionBudget.minAvailable` | Minimum available pods | `1` |
| `affinity` | Pod affinity/anti-affinity rules | `{}` |
| `resources.requests` | Resource requests | `memory: "256Mi", cpu: "100m"` |
| `resources.limits` | Resource limits | `memory: "512Mi", cpu: "500m"` |
| `healthCheck.enabled` | Enable health checks | `true` |
| `healthCheck.path` | Health check path | `"/"` |
| `healthCheck.port` | Health check port | `8000` |
| `appKey` | Application key (32-char, auto-generated if empty) | `""` |
| `appPort` | Application port | `8000` |
| `appBaseUrl` | Base URL of the application | `"http://localhost:8000"` |
| `appDashUrl` | Base URL of the admin dashboard | `"http://localhost:8000/dash"` |
| `appApiBaseName` | API namespace | `"api"` |
| `database.driver` | Database driver (sqlite, mysql, pgx) | `"sqlite"` |
| `database.name` | Database name | `""` |
| `database.host` | Database host | `"localhost"` |
| `database.port` | Database port | `""` |
| `database.user` | Database user | `""` |
| `database.password` | Database password | `""` |
| `database.existingSecret` | Existing secret for database password | `""` |
| `database.existingSecretPasswordKey` | Key in existing secret | `"password"` |
| `database.disableForeignKeys` | Disable foreign keys | `false` |
| `auth.enabled` | Enable auth configuration | `false` |
| `auth.enabledProviders` | List of enabled auth providers | `["local"]` |
| `auth.providers` | Auth provider configurations | `{}` |
| `storage.defaultDisk` | Default storage disk | `"public"` |
| `storage.disks` | Storage disk configurations | `[]` |
| `mail.senderName` | Mail sender name | `""` |
| `mail.senderMail` | Mail sender email | `""` |
| `mail.defaultClient` | Default mail client | `""` |
| `mail.clients` | Mail client configurations | `[]` |
| `persistence.enabled` | Enable persistence | `true` |
| `persistence.storageClassName` | Storage class name | `""` |
| `persistence.accessModes` | Access modes | `["ReadWriteOnce"]` |
| `persistence.size` | Storage size | `"10Gi"` |
| `persistence.mountPath` | Mount path | `"/fastschema/data"` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8000` |
| `service.targetPort` | Container port | `8000` |
| `ingress.enabled` | Enable ingress | `false` |
| `monitoring.serviceMonitor.enabled` | Enable ServiceMonitor | `false` |
| `monitoring.serviceMonitor.interval` | Scrape interval | `"30s"` |
| `monitoring.serviceMonitor.labels` | ServiceMonitor labels | `{}` |

## Ingress

**Note**: Ingress is disabled by default. AWS ALB ingress is managed by Terraform modules.

## Examples

See [EXAMPLES.md](EXAMPLES.md) for detailed usage examples including:

- Basic installation
- High availability setup
- Database configuration (SQLite, MySQL, PostgreSQL)
- Auth provider configuration (local, GitHub, Google, Twitter)
- Storage configuration (local, S3)
- Mail configuration
- ServiceMonitor setup
- Complete example

## Integration with Terraform

This chart is designed to work with Terraform modules that handle:

- AWS ALB ingress creation
- Cognito OIDC configuration (if needed)
- Database provisioning (RDS)
- Secrets management

Example Terraform usage:

```hcl
resource "helm_release" "fastschema" {
  name       = "fastschema"
  repository = "https://k8sforge.github.io/fastschema-chart"
  chart      = "fastschema"
  version    = "0.1.0"

  values = [
    yamlencode({
      replicaCount = 3
      database = {
        driver = "pgx"
        name   = "fastschema"
        host   = var.postgres_host
        user   = "fastschema"
        existingSecret = "postgres-secret"
      }
      persistence = {
        enabled = true
        size    = "20Gi"
      }
    })
  ]
}
```

## Requirements

- Kubernetes 1.19+
- Helm 3.0+
- (Optional) Prometheus Operator for ServiceMonitor

## Upgrading

```bash
helm upgrade fastschema k8sforge/fastschema
```

## Uninstalling

```bash
helm uninstall fastschema
```

## Notes

- `APP_KEY` is required and must be consistent across deployments. If not provided, it will be auto-generated.
- For HA, use external database (MySQL/PostgreSQL), not SQLite.
- Auth providers require OAuth client credentials (GitHub, Google, Twitter).
- Storage can be local or S3-compatible (configure via JSON).
- Mail configuration supports multiple SMTP clients.

## License

This chart is licensed under the MIT License. See [LICENSE](LICENSE) file.

## Contributing

Contributions are welcome! Please open an issue or pull request.

## References

- [FastSchema Documentation](https://fastschema.com/docs)
- [FastSchema Configuration](https://fastschema.com/docs/configuration.html)
- [FastSchema GitHub](https://github.com/fastschema/fastschema)
