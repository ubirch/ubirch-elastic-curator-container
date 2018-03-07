## ElasticSearch Curator container
This container will handle the cleanup of old logfile indices in a ElasticSearch Cluster.
Software used is the ElasticSearch Curator found at: (https://www.elastic.co/guide/en/elasticsearch/client/curator/current/pip.html)

For convenience it's packaged into a Docker Container.

Files:
 * config.yml - basic Curator configuration, parameterised to take ENV variables
 * action_delete.yml - Curator Action file to delete indices older than 14 days matching certain names
 * Dockerfile - Dockerfile to build a container with Curator and the config and action Files
 * curator-job.yml - A Kubernetes Job Manifest to run this containers once
 * curator-config.yml - A Kubernetes configMap to configure Curator Job/Pods


Please note that the default CMD in the container will use "--dry-run" so that no action is executed. You need to override this for real production use.

### Build

 To build the Dockercontainer use:
 <pre>
docker build -t ubirch-elastic-curator-container .
 </pre>


### Run
The Container already contains a config and action file. To configure the ElasticSearch host one can pass environment variables:

<pre>
docker run --rm -ti -e ES_LOG_HOST=<your.elastic.host> -e ES_LOG_PORT=9200 -e ES_LOG_PREFIX="/api/"  ubirch-elastic-curator-container
</pre>

The Curator will log to STDOUT

## Usage in Kubernetes
To use the Curator in Kubernetes you can run the Docker Container either as a Job (CronJob) or Pod. To make this most flexible the configuration
is completely taken from ConfigMap. The file _curator-config.yml_ contains the needed config.yml as well as the action_file.yml and is mounted into the Container during runtime.

<pre>
[...]
    volumeMounts:
      - mountPath: /opt/
        name: curator-config
[...]
volumes:
- name: curator-config
  configMap:
     name: curator-config
     defaultMode: 420
[...]
</pre>
