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

{{/*
Common labels
*/}}
{{- define "ng-v2t.labels" -}}
helm.sh/chart: {{ include "ng-v2t.chart" . }}
{{ include "ng-v2t.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ng-v2t.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ng-v2t.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ng-v2t.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ng-v2t.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ng-v2t.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "ng-v2t.core" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}


{{- define "ng-v2t.core-cfg" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}

{{- define "ng-v2t.dashboard" -}}
{{- printf "%s-core" (include "ng-v2t.fullname" .) -}}
{{- end -}}


{{- define "ng-v2t.history-pvc" -}}
{{- printf "%s-history" (include "ng-v2t.fullname" .) -}}
{{- end -}}


{{- define "ng-v2t.workspace-pvc" -}}
{{- printf "%s-workspace" (include "ng-v2t.fullname" .) -}}
{{- end -}}


{{- define "ng-v2t.traefik-host-prefix" -}}
{{- if $.Values.ingress.host}}{{- printf "Host(`%s`) &&" $.Values.ingress.host }}{{- end}}
{{- end -}}

