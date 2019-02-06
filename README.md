# r-workshop-dockerfile
Dockerfile for CBC R Workshop

For now, run with:

  docker run -p 15500:15500 -dit r-workshop-image:v2 bash -c 'cd /home/ubuntu; jupyter notebook --allow-root --ip 0.0.0.0'
