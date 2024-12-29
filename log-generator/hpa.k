schema HPA:
    namespace: str
    name: str
    deployment: str
    minReplicas: int
    maxReplicas: int

hpa = HPA {
    namespace = "sre-log-generator"
    name = "log-generator-hpa"
    deployment = "log-generator-deployment"
    minReplicas = 2
    maxReplicas = 4
}

output = {
    apiVersion = "autoscaling/v2"
    kind = "HorizontalPodAutoscaler"
    metadata = {
        name = hpa.name
        namespace = hpa.namespace
    }
    spec = {
        scaleTargetRef = {
            apiVersion = "apps/v1"
            kind = "Deployment"
            name = hpa.deployment
        }
        minReplicas = hpa.minReplicas
        maxReplicas = hpa.maxReplicas
        metrics = [
            {
                type = "Resource"
                resource = {
                    name = "cpu"
                    target = {
                        type = "Utilization"
                        averageUtilization = 50
                    }
                }
            }, {
                type = "Resource"
                resource = {
                    name = "memory"
                    target = {
                        type = "Utilization"
                        averageUtilization = 50
                    }
                }
            }
        ]
    }
}

