

# Newton V2T Helm package

## Global prerequisites
- Kubernetes cluster 1.22+
- Helm v3.8.0+
- Persistent volumes

**System does not store any user processed data**, only optionally persists diagnostic data.

All input/output data is processed only as in-memory stream. 

## Components

### Core

* API server, scheduler and gateway
* Uses Etcd for runtime data
* Stores historical data on filesystem or s3

### Dashboard

* Web interface for *Core* component

### Agent

* Scalable compute unit

## Storage

### Etcd

* Persistent KV store for *Core* runtime data. 
* Supports HA by running in 3/5 nodes cluster.
* Each instance requires persistent disk

### History persistent volume

* Historical diagnostic and monitoring data


## Deployment modes

### Single node setup with local path provisioner (e.g. k3s)

* one *Etcd*, *Core* and *Dashboard* replica
* number of *Agent* replicas based on resources required and available

```yaml
global:
  storageClass: local-path
persistence:
  accessModes:
    - ReadWriteOnce
```


### Highly available distributed mode
  
 ```yaml
global:
  storageClass: ceph-filesystem
core:
  replicaCount: 2
dashboard:
  replicaCount: 2
agent:
  replicaCount: 1
etcd:  
  replicaCount: 3
traefik:
  deployment:
    replicas: 2
```



