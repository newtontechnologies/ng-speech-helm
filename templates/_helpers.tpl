{{/*
Expand the name of the chart.
*/}}
{{- define "ng-v2t.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ng-v2t.fullname" -}}
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
{{- define "ng-v2t.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ng-v2t.labels" -}}
helm.sh/chart: {{ include "ng-v2t.chart" . }}
{{ include "ng-v2t.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "ng-v2t.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ng-v2t.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "ng-v2t.core" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.coreCfg" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.usersCfg" -}}
{{- printf "%s-users" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.traefik" -}}
{{- printf "%s-treafik" (include "ng-v2t.fullname" . ) -}}
{{- end -}}


{{- define "ng-v2t.agent" -}}
{{- printf "%s-agent" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.agentCfg" -}}
{{- printf "%s-agent" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.dashboard" -}}
{{- printf "%s-dashboard" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.historyPvc" -}}
{{- printf "%s-history" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.workspacePvc" -}}
{{- printf "%s-workspace" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.imagePullSecret" }}
{{- printf "%s-image-pull-secret" (include "ng-v2t.fullname" .) -}}
{{- end }}

{{- define "ng-v2t.imagePullSecretBody" }}
{{- with .Values.imagePullSecret }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .domain .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "ng-v2t.etcd" -}}
{{- printf "%s-etcd" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.etcdHeadlessService" -}}
{{- printf "%s-etcd-headless" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.etcdEndpoint" }}
{{- if .Values.etcd.enabled }}
{{- printf "%s:2379" (include "ng-v2t.etcd" .)  -}}
{{- else if .Values.core.config.etcd.endpoint }}
{{ .Values.core.config.etcd.endpoint }}
{{- else }}
localhost:2379
{{- end }}
{{- end }}

{{- define "ng-v2t.etcdPeers" -}}
{{- $result := list -}}
{{- $to := int .Values.etcd.replicaCount }}
{{- range $i := until $to -}}
{{- $result = (printf "%s-%d=http://%s-%d.%s.%v.svc.%s:2380" (include "ng-v2t.etcd" $ ) $i (include "ng-v2t.etcd" $ ) $i (include "ng-v2t.etcdHeadlessService" $) $.Release.Namespace $.Values.clusterDomain)  | append $result -}}
{{- end -}}
{{ join "," $result }}
{{- end -}}


{{- define "ng-v2t.traefikOptionalHostRule" -}}
{{- if .Values.traefikIngressRoute.host }}
{{- printf "Host(`%s`) && " .Values.traefikIngressRoute.host  -}}
{{- end }}
{{- end }}
