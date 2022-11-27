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

{{- define "ng-speech.coreImage" -}}
{{- with .Values.core.image }}
{{- if .distribution }}
{{- printf "%s:%s-%v" .repository  (.tag | default $.Chart.AppVersion) .distribution }}
{{- else -}}
{{- printf "%s:%s" .repository  (.tag | default $.Chart.AppVersion) }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "ng-speech.agentImage" -}}
{{- if .image.distribution }}
{{- printf "%s:%s-%v" .image.repository  (.image.tag | default .Chart.AppVersion) .image.distribution }}
{{- else -}}
{{- printf "%s:%s" .image.repository  (.image.tag | default .Chart.AppVersion) }}
{{- end -}}
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

{{- define "ng-speech.traefikOptionalHostRule" -}}
{{- if .Values.traefikIngressRoute.host }}
{{- printf "Host(`%s`) && " .Values.traefikIngressRoute.host  -}}
{{- end }}
{{- end }}
