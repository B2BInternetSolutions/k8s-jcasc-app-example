FROM adoptopenjdk/openjdk11:ubi-minimal

ARG VERSION=1.0.0
LABEL Description="Reddot application for k8s-jcasc-mgmt example" Vendor="K8S_MGMT" Version="${VERSION}"

COPY devops/entrypoint.sh /app/entrypoint.sh
COPY build/libs/reddot-0.1.jar /app/app.jar

ENTRYPOINT ["/app/entrypoint.sh", "app"]