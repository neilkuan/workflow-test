# 使用官方 nginx 映像作為基礎
FROM nginx:alpine AS builder

# 設置工作目錄
WORKDIR /app

# 複製 nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 第二階段：使用更小的基礎映像
FROM nginx:alpine

# 複製第一階段的配置文件
COPY --from=builder /etc/nginx/nginx.conf /etc/nginx/nginx.conf

# 設置非 root 用戶
RUN chown -R nginx:nginx /var/cache/nginx /var/log/nginx /var/run \
    && chmod -R 755 /var/cache/nginx /var/log/nginx /var/run

# 使用非 root 用戶運行
USER nginx

# 暴露端口
EXPOSE 80

# 健康檢查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

# 啟動 nginx
CMD ["nginx", "-g", "daemon off;"]

