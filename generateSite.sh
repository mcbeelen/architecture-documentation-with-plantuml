
rm -rf build

docker run -u $(id -u) --network=host \
  -v $PWD:/antora:Z \
  --rm -t antora/antora-with-kroki-and-lunr \
  --cache-dir=./.cache/antora antora-playbook.yml

echo "serve build/site"
