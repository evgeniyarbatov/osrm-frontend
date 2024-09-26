URLS = \
    https://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf

OUTPUT_DIR = osm

all: docker

download:
	@for url in $(URLS); do \
	    filename=$$(basename $$url); \
	    if [ ! -f $(OUTPUT_DIR)/$$filename ]; then \
	        wget $$url -P $(OUTPUT_DIR); \
	    fi \
	done

docker: download
	@open -a Docker
	@while ! docker info > /dev/null 2>&1; do \
		sleep 1; \
	done
	@docker stop $$(docker ps -a -q)
	@docker compose up --build -d

.PHONY: all download