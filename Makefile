


.PHONY: release
release:
	helm package . -d docs
	helm repo index docs --url https://newtontechnologies.github.io/ng-speech-helm
