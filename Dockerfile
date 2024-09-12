FROM nginx AS runner

FROM scratch AS exporter

COPY --from=runner /etc/nginx/nginx.conf .