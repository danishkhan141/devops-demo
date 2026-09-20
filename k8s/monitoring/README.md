# Local monitoring

This directory contains a lightweight Prometheus and Grafana setup for the
local Minikube cluster. It uses `kube-prometheus-stack` and discovers the
Spring Boot application through a `ServiceMonitor`.

## Install or upgrade

Add and refresh the Prometheus Community Helm repository:

```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Install the pinned chart using the project values:

```powershell
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack `
    --version 91.4.1 `
    --namespace monitoring `
    --create-namespace `
    --values k8s/monitoring/values.yaml `
    --wait `
    --timeout 10m
```

Create the Spring Boot scrape target after the chart has installed the
`ServiceMonitor` custom resource definition:

```powershell
kubectl apply -f k8s/monitoring/service-monitor.yaml
```

## Verify

```powershell
helm list --namespace monitoring
kubectl get pods --namespace monitoring
kubectl get servicemonitor devops-demo --namespace devops-demo
```

Prometheus should report two healthy targets for this query:

```promql
up{job="devops-demo"}
```

## Access Grafana

Decode the generated administrator password locally:

```powershell
$encoded = kubectl get secret monitoring-grafana `
    --namespace monitoring `
    -o jsonpath="{.data.admin-password}"

[Text.Encoding]::UTF8.GetString(
    [Convert]::FromBase64String($encoded)
)
```

Do not commit or share the generated password. Start a local port-forward:

```powershell
kubectl port-forward service/monitoring-grafana 3000:80 `
    --namespace monitoring
```

Open `http://localhost:3000` and sign in as `admin`.
