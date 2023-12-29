# CI/CD Docker image

This is Docker image for CI/CD with Composer, Node and Laravel Envoy.

1. [Building](#building)
    - [Environment file](#environment-file)
1. [Using](#using)
    - [Node](#node)

## Building

For building this image you need execute:
```sh
./build.sh
```

> **NOTE**  
> Because build script use **--squash**, use must enable experimental functionality for docker daemon

### Environment file

For creating environment file you need execute:
```sh
cp .env.example .env
```
After that you should fill environment variables in created `.env` file.

## Using

### Node

You can use default version of Node or choose specific version. For example:
```yml
# .gitlab-ci.yml
...
deploy-current-branch:
  stage: deploy
  image: groupbwt/gitlab-runner-envoy-node:latest
  script:
    - nvm install 16.20.2
    - nvm use 16.20.2
    - npm install
    - npm run build
```