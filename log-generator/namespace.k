schema Namespace:
    name: str

namespace = Namespace {
    name = "sre-log-generator"
}

output = {
    apiVersion = "v1"
    kind = "Namespace"
    metadata = {
        name = namespace.name
    }
}
