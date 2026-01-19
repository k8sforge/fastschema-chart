# FastSchema Helm Chart Repository

![Auto Tag Release](https://github.com/k8sforge/fastschema-chart/actions/workflows/chart-releaser.yml/badge.svg)

This is a Helm chart repository for the [FastSchema](https://fastschema.com/) Helm chart.

## Quick Start

### Add the Repository

```bash
helm repo add fastschema https://k8sforge.github.io/fastschema-chart
helm repo update
```

### Install the Chart

```bash
helm install my-fastschema fastschema/fastschema --version <version>
```

### List Available Versions

```bash
helm search repo fastschema/fastschema --versions
```

## Chart Information

- **Chart Name**: `fastschema`
- **Repository**: `https://k8sforge.github.io/fastschema-chart`
- **Latest Version**: See [index.yaml](index.yaml) for available versions

## Documentation

For complete documentation, configuration options, and examples, visit the [main repository](https://github.com/k8sforge/fastschema-chart).

## Alternative: OCI Installation

This chart is also available via OCI registry:

```bash
helm install my-fastschema \
  oci://ghcr.io/k8sforge/fastschema-chart/fastschema \
  --version <version>
```

## Support

- **Issues**: [GitHub Issues](https://github.com/k8sforge/fastschema-chart/issues)
- **Source Code**: [GitHub Repository](https://github.com/k8sforge/fastschema-chart)
- **FastSchema Documentation**: [https://fastschema.com/docs](https://fastschema.com/docs)
