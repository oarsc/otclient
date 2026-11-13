## Creating Docker Image

Create the docker image by using the Dockerfile with:
```sh
docker buildx build -t otbi -f Dockerfile .
tools/do
```

## Creating the container and building

Run the next command to create the command and build the code for the first time:
```sh
docker run --network=host -itv $PWD:/otclient --name otb otbi
```

Once the container is created, building can be triggered with:

```sh
docker start -a otb
```

To stop building, simply run:

```sh
docker stop otb
```

## Distrobox commands

Create:
```sh
distrobox create --name otb --image otbi --volume "$PWD:/otclient" --nvidia
tools/dtb
```

Compile:
```sh
distrobox enter otb -- /otclient/compile.sh
tools/dtb /otclient/compile.sh
```

Run:
```sh
distrobox enter otb -- /otclient/build/otclient
tools/dtb /otclient/build/otclient
```