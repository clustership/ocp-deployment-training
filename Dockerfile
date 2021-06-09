FROM node as builder

RUN mkdir -p /src
WORKDIR /src

RUN git clone https://github.com/clustership/vue-todos.git \
    && cd vue-todos \
    && yarn install \
    && yarn build

# FROM registry.redhat.io/ubi8
FROM registry.access.redhat.com/ubi8/nginx-118

# Add application sources
COPY --from=builder /src/vue-todos/dist ./

USER 1001

CMD ["nginx", "-g", "daemon off;"]
