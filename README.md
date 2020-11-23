# Docker build image
```
docker build --pull --rm -f "Docker\Dockerfile" -t libpostal:latest "Docker"
```

# Docker run container
```
docker run -it -p 5678:5678 -p 8888:8888 -p 22:22 libpostal:latest /bin/bash
```