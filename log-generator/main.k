import namespace
import secret
import deployment
import service
import ingress
import hpa

resources = [
    namespace.output
    secret.output
    deployment.output
    service.output
    ingress.output
    hpa.output
]
# output = resources
