#!/bin/bash
## Set the version as a local environment variable
VERSION="1.0.0"

## Set these parameters if not pre-loaded as environment variables
# google_maps_elevation_api_key=""
# tdar_un=""
# tdar_pw=""

### Build the vignette in a docker container
## Remove any previous containers
docker rm gutaker2020_rice_niche
docker rmi gutaker2020_rice_niche

## Build the Docker image from the github repo
docker build -t gutaker2020_rice_niche .

## Create the Docker container
docker create --name gutaker2020_rice_niche gutaker2020_rice_niche

## Start the Docker container
docker start gutaker2020_rice_niche

## Build the vignette
docker exec gutaker2020_rice_niche r -e "rmarkdown::render('/gutaker2020_rice_niche/vignettes/gutaker2020_rice_niche.Rmd', \
                                                        params = list(cores = 1, \
                                                                      clean = FALSE, \
                                                                      google_maps_elevation_api_key = '$google_maps_elevation_api_key', \
                                                                      tdar_un = '$tdar_un',\
                                                                      tdar_pw = '$tdar_pw'))"

## Make a Zenodo directory
rm -r docker_out; mkdir docker_out

## Copy the output from the container to the host
docker cp gutaker2020_rice_niche:/gutaker2020_rice_niche ./docker_out/

## Stop the Docker container
docker stop gutaker2020_rice_niche
