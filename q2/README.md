# Container Runtime
How to run this code? 

1. install Golang
```
apt install golang
```
2. Download ubuntu 20.04 base image and put it to ./ubuntu-fs
```
curl -O https://partner-images.canonical.com/oci/focal/current/ubuntu-focal-oci-amd64-root.tar.gz

mkdir ubuntu-fs
tar -xf ubuntu-focal-oci-amd64-root.tar.gz -C ./ubuntu-fs

```
3. Run main.go
``` 
go run main.go run <host-name>
```