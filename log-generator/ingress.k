schema Ingress:
    namespace: str
    name: str
    host: str

ingress = Ingress {
    namespace = "sre-log-generator"
    name = "log-generator-ingress"
    host = "log-generator.local"
}

output = {
    apiVersion = "networking.k8s.io/v1"
    kind = "Ingress"
    metadata = {
        name = ingress.name
        namespace = ingress.namespace
        annotations = {
            "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
            "nginx.ingress.kubernetes.io/rewrite-target" = "/"
            "nginx.ingress.kubernetes.io/proxy-body-size" = "10m"
        }
    }
    spec = {
        ingressClassName = "nginx"
        rules = [{
            host = ingress.host
            http = {
                paths = [{
                    path = "/"
                    pathType = "Prefix"
                    backend.service = {
                        name = "log-generator-service"
                        port.number = 80
                    }
                }]
            }
        }]
    }
}

