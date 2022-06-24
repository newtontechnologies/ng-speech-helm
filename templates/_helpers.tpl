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

{{- define "ng-v2t.coreServiceAccountName" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end }}

{{- define "ng-v2t.coreRoleName" -}}
{{- printf "%s-core-role" (include "ng-v2t.fullname" .) -}}
{{- end }}

{{- define "ng-v2t.coreRoleBindingName" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end }}

{{- define "ng-v2t.core" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.coreCfg" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.agent" -}}
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
{{- with .Values.registry }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .domain .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "ng-v2t.staticServices" }}
{{- range $idx, $k := .Values.services }}
{{- if hasKey $.Values.catalog $k}}
- service: {{ $k }}
  version: {{ (get $.Values.catalog $k).version }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ng-v2t.etcdPvPrefix" }}
{{- printf "%s-etcd-%s" .Release.Name . -}}
{{- end }}

{{- define "ng-v2t.etcdHostPort" }}
{{- printf "%s-etcd:2379" .Release.Name -}}
{{- end }}

