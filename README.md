# Generate a static site from AsciiDoc with PlantUML.

## Requirements

1. Content in version control
1. Content is written [AsciiDoc](https://docs.asciidoctor.org/asciidoc/latest/)
1. Diagrams are written in .puml-files with [PlantUML](https://plantuml.com/)-syntax
1. Site should have a search feature.
1. Build building the site must be done in docker containers

## Solution

The overall solution was build combining:

* [Antora](https://antora.org/)
* [Kroki](https://kroki.io/)
* [LUNR](https://lunrjs.com/)

## Setup 
In order to use this combination, they needed to be combined into a single custom docker image.

This repo contains a [Dockerfile](docker/antora/Dockerfile), which can build that image.
The [buildContainer.sh](docker/antora/buildContainer.sh) stores is it locally as `local/antora-with-kroki-and-lunr`

### Reference info for building the docker image

* [Antora](https://docs.antora.org/antora/latest/antora-container/#extend-the-antora-image)
* [asciidoctor-kroki](https://github.com/ggrossetie/asciidoctor-kroki)
* [@antora/lunr-extension](https://gitlab.com/antora/antora-lunr-extension)


### Using Your Own Kroki

I did not want to use the public kroki.io-server, I decided to run my [own kroki](https://github.com/ggrossetie/asciidoctor-kroki#using-your-own-kroki) in docker.

```shell
docker compose -f docker/kroki/docker-compose.yml up 
```

I expose kroki-locally on port 28000, and therefor the [antora-playbook](antora-playbook.yml) contains a attributes to point the kroki-server-url: http://kroki-server:28000
(I map kroki-server to 127.0.0.1 in my hosts-file)

## Run antora with the custom image

```shell
docker run -u $(id -u) --network=host \
  -v $PWD:/antora:Z \
  --rm -t local/antora-with-kroki-and-lunr \
  --cache-dir=./.cache/antora antora-playbook.yml
```

Expected output:

```shell
Site generation complete!
```

### Quick script

```shell
./generateSite.sh
```

## Local preview

Using [Vercel Serve](https://github.com/vercel/serve)

```shell
npm install --global serve
serve build/site
```
Open the preview: [http://localhost:3000](http://localhost:3000)

### Fixed for broken links

If the generate site contains any `index.html`, the default behaviour of Serve is to clean those urls and redirect to directory (`/docs/main/index.htm` --> `/docs/main`) This causes problems with relative links in images and navigation, since the miss the 'version-part' in the URL. To fix this, this repo includes a `[serve.json](supplemental-ui/serve.json) and includes that as a static-file to configure serve. to disable the [option to clean URLs](https://github.com/vercel/serve-handler#options).



