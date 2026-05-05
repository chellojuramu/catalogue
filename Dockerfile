FROM node:20.20.2-alpine3.23 AS builder
WORKDIR /app
COPY package.json .
COPY *.js .
RUN npm install


FROM node:20.20.2-alpine3.23
WORKDIR /app
EXPOSE 8080
COPY --from=builder /app /app 
ENV MONGO="true" \
      MONGO_URL="mongodb://mongodb:27017/catalogue"
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
      apk --no-cache update && apk --no-cache upgrade
RUN chown -R roboshop:roboshop /app
USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]



# ---------- Stage 1 ----------
# FROM node:20.20.2-alpine3.23 AS builder

# WORKDIR /app

# COPY package.json .
# COPY *.js .
# RUN npm install

# # ---------- Stage 2 ----------
# FROM gcr.io/distroless/nodejs20-debian13:nonroot

# WORKDIR /app

# LABEL project="roboshop" \
#       service="catalogue" \
#       owner="ramu"

# EXPOSE 8080

# COPY --from=builder /app /app

# # ENV removed — handled by Kubernetes ConfigMap


# CMD ["server.js"]