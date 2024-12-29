schema Service:
    namespace: str
    name: str

service = Service {
    namespace = "sre-log-generator"
    name = "log-generator-service"
}

output = {
    apiVersion = "v1"
    kind = "Service"
    metadata = {
        name = service.name
        namespace = service.namespace
        labels = {
            app = "log-generator"
        }
    }
    spec = {
        selector = {
            app = "log-generator"
        }
        ports = [{
            protocol = "TCP"
            port = 80
            targetPort = 8080
        }]
        type = "ClusterIP"
    }
}

