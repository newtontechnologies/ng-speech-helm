

# Newton V2T Helm package

## Global prerequisites
- Kubernetes cluster 1.22+
- Helm v3.8.0+
- Persistent volumes

**System does not store any user processed data**, only optionally persists diagnostic data.

All input/output data is processed only as in-memory stream. 

## Components

### Core

* API server, scheduler and agent load balancer 
* Uses Etcd for runtime data
* Stores historical data on disk
* Stores agent bootstrap data on disk 

### Dashboard

* Web interface for *Core* component. 

### Agent

* Scalable compute unit

## Storage

### Etcd

* Persistent KV store for *Core* runtime data. 
* Supports HA by running in 3/5 nodes cluster.
* Each instance requires persistent disk

### History persistent volume

* Historical diagnostic and monitoring data

### Workspace persistent volume

* Agent bootstrap and runtime data


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




```


## Agent resources



## Etcd performance


### Disaster recovery

* Losing history PV
    * historical data is lost, runtime data is not affected
    * replace volume
    * restart *Core* deployment
* Losing workspace PV
    * agents will fail to process new requests
    * replace volume
    * restart *Core* and *Agent* deployment
    * missing data will be re-downloaded upon *Core* (leader) restart
    * watch *Core* (leader) logs till service import finished
* Losing *Etcd* cluster (without backup)
    * Perform clean install  (optionally keeping history volume)
    * you will lose user objects data (login, permissions)
        * may not matter when using only default account
    * other data will be recreated after restart







### Publish

1. Package
```shell
helm package .
```
2. Publish
```shell
helm push ng-v2t-$(VERSION).tgz oci://$(REGISTRY)/helm-charts/ng-v2t
```
