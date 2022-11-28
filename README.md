# Newton V2T Helm package

## Prerequisites

- Kubernetes cluster 1.21+
- License token

All input/output data is processed only as in-memory stream. System does not store or send any processed data.

## Components

### Core

* API server, scheduler and gateway
* Uses Etcd for data persistence

### Agent

* Compute unit

### Traefik

* Optional service proxy

## Deployment modes

### Minimal configuration

```yaml
core:
  config:
    license:
      token: "_LICENSE_TOKEN_"
    agent:
      count: 1
```

### Distributions

```yaml
agent:
  default:
    image:
      distribution: cz # distribution containing czech language service pack
```

See [ng-speech-agent](https://hub.docker.com/r/newtontechnologies/ng-speech-agent/tags) for list of all available
options.

## Configuration

List of selected configuration options

| Parameter                             | Description                                                                            | Default          |
|---------------------------------------|----------------------------------------------------------------------------------------|------------------|
| `core.config.license.token`           | License token                                                                          | ``               |
| `core.config.admin.username`          | Admin username                                                                         | `ngadmin`        |
| `core.config.admin.password`          | Admin password                                                                         | `ngadmin`        |
| `core.config.login.jwt.key`           | Key used for symmetric JWT token encryption                                            | `insecure-key`   |
| `core.config.agent.token`             | Token used for agent to core authentication                                            | `insecure-token` |
| `core.config.agent.count`             | Token used for agent to core authentication                                            | `insecure-token` |
| `core.config.sharedWorkspace.enabled` | Enables storing data on RWX shared volume,                                             | `false`          |
| `agent.image.distribution`            | Agent image distribution                                                               | `all`            |
| `agent.replicaCount`                  | Number of agent replicas. Each agent can handle single request at a time               | `1`              |
| `traefikIngressRoute.enabled`         | Install Traefik IngressRoute for ingress traffic                                       | `true`           |

