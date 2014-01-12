.PHONY: build run ssh base

UBUNTUBASE = saucy

all: 
	@echo "Run make with"
	@echo "  build - build the new image"
	@echo "  run   - start the docker"
	@echo "  ssh   - connect to the docker"

base:
	sudo debootstrap $(UBUNTUBASE) $(UBUNTUBASE)
	sudo tar -C $(UBUNTUBASE) -c . | sudo docker import - $(UBUNTUBASE)

build: Dockerfile
	sudo docker build -t dwagon/sshd .

run:
	sudo docker run -d dwagon/sshd > .containerid
	sudo docker inspect `cat .containerid` | grep IPAddress | awk '{ print $$2 }' | tr -d ',"' > .ipaddress

ssh:
	ssh root@`cat .ipaddress`
