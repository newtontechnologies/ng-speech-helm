### Publish

1. Package
```shell
helm package .
```
2. Publish
```shell
helm push ng-v2t-$(VERSION).tgz oci://docker.io/newtontechnologies/ng-v2t-helm
```
