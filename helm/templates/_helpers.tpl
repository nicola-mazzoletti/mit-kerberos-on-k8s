{{/* Generate a full name for the resources */}}
{{- define "mit-kerberos.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/* Short name helper */}}
{{- define "mit-kerberos.name" -}}
{{- .Chart.Name -}}
{{- end }}
