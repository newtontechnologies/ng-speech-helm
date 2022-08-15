



package:
	helm package . -d docs

index:
	helm repo index docs --url https://newtontechnologies.github.io/ng-speech-helm
	git add docs/\*

.PHONY: release
release: package index


