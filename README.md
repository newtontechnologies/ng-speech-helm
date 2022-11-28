# Newton V2T Helm package

## Prerequisites

- Kubernetes cluster 1.21+
- License token

All input/output data is processed only as in-memory stream. System does not store or send any processed data.


## Deployment modes

### Embedded agents

```yaml
core:
  config:
    license:
      token: "_LICENSE_TOKEN_"
    agent:
      count: 4
```

### External agents with shared workspace 

1. Requires storage with `read-write-many` support

```yaml
core:
  config:
    license:
      token: "_LICENSE_TOKEN_"
    agent:
      count: 0
    sharedWorkspace:
      persistence:
        enabled: true
        size: 100Gi    
agents:
  default:
    count: 24
  config:
    sharedWorkspace:
      enabled: true
```

### External agents with custom bundled models
```yaml
core:
  image:
    repository: mycompany/ng-core-custom
    tag: 2.0.1-west-eu
  config:    
    license:
      token: "_LICENSE_TOKEN_"
agents:  
  default:
    image:
      repository: mycompany/ng-core-custom
      tag: 2.0.1-west-eu
    count: 24
```

## Configuration

List of selected configuration options

| Parameter                                         | Description                                                              | Default          |
|---------------------------------------------------|--------------------------------------------------------------------------|------------------|
| `core.config.license.token`                       | License token                                                            | ``               |
| `core.config.admin.username`                      | Admin username                                                           | `ngadmin`        |
| `core.config.admin.password`                      | Admin password                                                           | `ngadmin`        |
| `core.config.login.jwt.key`                       | Key used for symmetric JWT token encryption                              | `insecure-key`   |
| `core.config.agent.token`                         | Token used for agent to core authentication                              | `insecure-token` |
| `core.config.agent.count`                         | Number of core embedded agents                                           | `insecure-token` |
| `core.config.sharedWorkspace.persistence.enabled` | Enables storing data on RWX shared volume,                               | `false`          |
| `agent.default.count`                             | Number of agent replicas. Each agent can handle single request at a time | `1`              |
| `traefikIngressRoute.enabled`                     | Install Traefik IngressRoute for ingress traffic                         | `true`           |



## Packaging
```bash
helm package .
helm push ng-speech-$version.tgz oci://registry-1.docker.io/newtontechnologies
```
