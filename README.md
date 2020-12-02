# Docker build image
```
docker build --pull --rm -t libpostal:latest .
```

# Docker run container
```
docker run -it -p 5678:5678 -p 8080:8080 -p 22:22 -v rootpostal:/root libpostal:latest /bin/bash
```
