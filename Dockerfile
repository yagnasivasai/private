FROM gcr.io/mig-elgt/osrm-fetcher:v4 as fetcher

FROM osrm/osrm-backend:v5.22.0
RUN apt-get update && apt-get install -y ca-certificates
RUN update-ca-certificates
COPY --from=fetcher /usr/local/bin/app /usr/local/bin/fetcher
RUN chmod +x /usr/local/bin/fetcher

EXPOSE 5000

FROM osrm/osrm-backend

# Set the working directory inside the container
WORKDIR /data

# Copy the OSM data file to the container
COPY north-eastern-zone-latest.osrm /data/north-eastern-zone-latest.osrm

# Run osrm-routed with specified algorithm
CMD ["osrm-routed", "--algorithm", "mld", "north-eastern-zone-latest.osrm"]


docker build .
docker tag id osrm
docker run -itd --name osrm osrm:v1
docker exec --it id /bin/bash
