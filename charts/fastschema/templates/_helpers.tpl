{{/*
Expand the name of the chart.
*/}}
{{- define "fastschema.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "fastschema.fullname" -}}
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
{{- define "fastschema.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fastschema.labels" -}}
helm.sh/chart: {{ include "fastschema.chart" . }}
{{ include "fastschema.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fastschema.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fastschema.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Generate AUTH environment variable as JSON string
*/}}
{{- define "fastschema.authJson" -}}
{{- if .Values.auth.enabled }}
{{- $authConfig := dict "enabled_providers" .Values.auth.enabledProviders "providers" .Values.auth.providers }}
{{- $authConfig | toJson }}
{{- end }}
{{- end }}

{{/*
Generate STORAGE environment variable as JSON string
*/}}
{{- define "fastschema.storageJson" -}}
{{- $storageConfig := dict "default_disk" .Values.storage.defaultDisk "disks" .Values.storage.disks }}
{{- $storageConfig | toJson }}
{{- end }}

{{/*
Generate MAIL environment variable as JSON string
*/}}
{{- define "fastschema.mailJson" -}}
{{- if and .Values.mail.senderName .Values.mail.senderMail }}
{{- $mailConfig := dict "sender_name" .Values.mail.senderName "sender_mail" .Values.mail.senderMail "default_client" .Values.mail.defaultClient "clients" .Values.mail.clients }}
{{- $mailConfig | toJson }}
{{- end }}
{{- end }}
