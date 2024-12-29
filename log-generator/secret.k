import base64

schema Secret:
    namespace: str
    name: str
    server_address: str

secret = Secret {
    namespace = "sre-log-generator"
    name = "log-generator-secret"
    server_address = base64.encode(":8080")
}

output = {
    apiVersion = "v1"
    kind = "Secret"
    metadata = {
        name = secret.name
        namespace = secret.namespace
    }
    type = "Opaque"
    data = {
        server_address = secret.server_address
    }
}
