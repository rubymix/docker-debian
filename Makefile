DOCKER_REPO=rubymix/debian

build:
	docker build --no-cache -t ${DOCKER_REPO} .

clean:
	-docker rmi ${DOCKER_REPO}

run: build
	docker run --rm -u ${UID}:${GROUPS} -t -i ${DOCKER_REPO}

push: build
	docker push ${DOCKER_REPO}