### Publish

1. Package
```shell
helm package . -d docs
```
2. Publish
```shell
helm push ng-speech.$(VERSION).tgz oci://docker.io/newtontechnologies/ng-speech.helm
```
