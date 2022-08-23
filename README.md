# Newton V2T Helm package

## Prerequisites

- Kubernetes cluster 1.21+
- License token

All input/output data is processed only as in-memory stream. System does not store or send any processed data.

## Components

### Core

* API server, scheduler and gateway
* Uses Etcd for data persistence

### Dashboard

* Web interface for *Core* component

### Agent

* Compute unit

### Etcd

* Persistent KV store for *Core* runtime data.

### Traefik

* Optional service proxy

## Deployment modes

### Minimal configuration

```yaml
core:
  config:
    license:
      token: "_LICENSE_TOKEN_"
```

### Highly available mode

 ```yaml
core:
  replicaCount: 2
dashboard:
  replicaCount: 2
etcd:
  replicaCount: 3
traefik:
  deployment:
    replicas: 2
```

### Distributions

```yaml
agent:
  image:
    distribution: cz # distribution containing czech language service pack
```

See [ng-speech-agent](https://hub.docker.com/r/newtontechnologies/ng-speech-agent/tags) for list of all available
options.

## Configuration

List of selected configuration options

| Parameter                             | Description                                                                            | Default          |
|---------------------------------------|----------------------------------------------------------------------------------------|------------------|
| `core.config.license`                 | License token                                                                          | ``               |
| `core.replicaCount`                   | Number of core replicas. Set to `2` for HA setup                                       | `1`              |
| `core.config.admin.username`          | Admin username                                                                         | `ngadmin`        |
| `core.config.admin.password`          | Admin password                                                                         | `ngadmin`        |
| `core.config.login.jwt.key`           | Key used for symmetric JWT token encryption                                            | `insecure-key`   |
| `core.config.registry.token`          | Token used for agent to core authentication                                            | `insecure-token` |
| `core.config.history.chunkLimit`      | Number of history chunks to keep in etcd (single chunk stores ~ 1000 historic entries) | `100`            |
| `core.config.sharedWorkspace.enabled` | Enables storing data on RWX shared volume,                                             | `false`          |
| `agent.image.distribution`            | Agent image distribution                                                               | `all`            |
| `agent.replicaCount`                  | Number of agent replicas. Each agent can handle single request at a time               | `1`              |
| `traefikIngressRoute.enabled`         | Install Traefik IngressRoute for ingress traffic                                       | `true`           |

