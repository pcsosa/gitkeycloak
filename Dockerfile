FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENV KC_DB_URL=postgresql://cmsis2_user:CQR8p0SIPKBuTkL3ozC21lKggbMVda7C@dpg-cr8j4nij1k6c73f3gp0g-a/cmsis2
ENV KC_DB_USERNAME=cmsis2_user
ENV KC_DB_PASSWORD=CQR8p0SIPKBuTkL3ozC21lKggbMVda7C
ENV KC_HOSTNAME=dpg-cr8j4nij1k6c73f3gp0g-a
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]