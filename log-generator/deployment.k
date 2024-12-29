schema Deployment:
    namespace: str
    name: str
    replicas: int
    image: str
    server_address_key: str

# Use option() with a default value to handle missing params
params = option("params") or {}

deployment = Deployment {
    namespace = "sre-log-generator"
    name = "log-generator-deployment"
    replicas = params.replicas if "replicas" in params else 2
    image = params.image if "image" in params else "ttl.sh/default-image:latest"
    server_address_key = "server_address"
}

output = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
        name = deployment.name
        namespace = deployment.namespace
        labels = {
            app = "log-generator"
        }
    }
    spec = {
        replicas = deployment.replicas
        selector = {
            matchLabels = {
                app = "log-generator"
            }
        }
        template = {
            metadata = {
                labels = {
                    app = "log-generator"
                }
            }
            spec = {
                containers = [{
                    name = "log-generator"
                    image = deployment.image
                    ports = [{containerPort = 8080}]
                    env = [
                        {
                            name = "SERVER_ADDRESS"
                            valueFrom.secretKeyRef = {
                                name = "log-generator-secret"
                                key = deployment.server_address_key
                            }
                        }
                        {
                            name = "OTEL_SERVICE_NAME"
                            value = "log-generator"
                        }
                        {
                            name = "OTEL_TRACES_SAMPLER"
                            value = "always_on"
                        }
                    ]
                    livenessProbe = {
                        httpGet = {
                            path = "/healthz"
                            port = 8080
                        }
                        initialDelaySeconds = 10
                        periodSeconds = 15
                    }
                    readinessProbe = {
                        httpGet = {
                            path = "/healthz"
                            port = 8080
                        }
                        initialDelaySeconds = 5
                        periodSeconds = 10
                    }
                    resources = {
                        requests = {
                            memory = "128Mi"
                            cpu = "250m"
                        }
                        limits = {
                            memory = "512Mi"
                            cpu = "500m"
                        }
                    }
                    securityContext = {
                        runAsUser = 1000
                        runAsGroup = 3000
                        readOnlyRootFilesystem = True
                        allowPrivilegeEscalation = False
                    }
                }]
            }
        }
    }
}
