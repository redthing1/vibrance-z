set -e
export TAG=runner_$(head /dev/urandom | tr -dc a-z0-9 | head -c10)
podman build -t $TAG -f run.docker && podman run --rm -it  --network host -v $(pwd):/prj $TAG 