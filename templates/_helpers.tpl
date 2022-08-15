{{/*
Expand the name of the chart.
*/}}
{{- define "ng-speech.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ng-speech.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ng-speech.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ng-speech.labels" -}}
helm.sh/chart: {{ include "ng-speech.chart" . }}
{{ include "ng-speech.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "ng-speech.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ng-speech.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "ng-speech.core" -}}
{{- printf "%s-core" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.coreCfg" -}}
{{- printf "%s-core" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.usersCfg" -}}
{{- printf "%s-users" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.traefik" -}}
{{- printf "%s-treafik" (include "ng-speech.fullname" . ) -}}
{{- end -}}


{{- define "ng-speech.agent" -}}
{{- printf "%s-agent" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.agentCfg" -}}
{{- printf "%s-agent" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.dashboard" -}}
{{- printf "%s-dashboard" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.historyPvc" -}}
{{- printf "%s-history" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.workspacePvc" -}}
{{- printf "%s-workspace" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.imagePullSecret" }}
{{- printf "%s-image-pull-secret" (include "ng-speech.fullname" .) -}}
{{- end }}

{{- define "ng-speech.imagePullSecretBody" }}
{{- with .Values.imagePullSecret }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .domain .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "ng-speech.etcd" -}}
{{- printf "%s-etcd" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.etcdHeadlessService" -}}
{{- printf "%s-etcd-headless" (include "ng-speech.fullname" .) -}}
{{- end -}}

{{- define "ng-speech.etcdEndpoint" }}
{{- if .Values.etcd.enabled }}
{{- printf "%s:2379" (include "ng-speech.etcd" .)  -}}
{{- else if .Values.core.config.etcd.endpoint }}
{{ .Values.core.config.etcd.endpoint }}
{{- else }}
localhost:2379
{{- end }}
{{- end }}

{{- define "ng-speech.etcdPeers" -}}
{{- $result := list -}}
{{- $to := int .Values.etcd.replicaCount }}
{{- range $i := until $to -}}
{{- $result = (printf "%s-%d=http://%s-%d.%s.%v.svc.%s:2380" (include "ng-speech.etcd" $ ) $i (include "ng-speech.etcd" $ ) $i (include "ng-speech.etcdHeadlessService" $) $.Release.Namespace $.Values.clusterDomain)  | append $result -}}
{{- end -}}
{{ join "," $result }}
{{- end -}}

{{- define "ng-speech.traefikOptionalHostRule" -}}
{{- if .Values.traefikIngressRoute.host }}
{{- printf "Host(`%s`) && " .Values.traefikIngressRoute.host  -}}
{{- end }}
{{- end }}
