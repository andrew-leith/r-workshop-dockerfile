FROM ubuntu:16.04
LABEL maintainer "Andrew Leith <andrew_leith@brown.edu>"
LABEL repository aleith/r-workshop
LABEL image r-workshop-ubuntu
LABEL tag v1

RUN apt-get update -y \
    && apt-get -y install wget \
    && apt-get -y install sudo \
    && apt-get -y install git \
    && apt-get -y install screen \
    && wget https://s3.us-east-2.amazonaws.com/brown-cbc-amis/package_list.txt \
    && apt-get -y install $(grep -vE "^\s*#" package_list.txt  | tr "\n" " ") \
    && apt clean all

RUN useradd -m -d /home/ubuntu -s /bin/bash ubuntu \
    && echo "ubuntu ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu \
    && echo "PATH=/home/ubuntu/R-3.4.3/bin:$PATH" >> /home/ubuntu/.profile \
    && /bin/bash -c "source /home/ubuntu/.profile"

USER ubuntu
ENV HOME /home/ubuntu

RUN cd /home/ubuntu \
 && wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh \
 && bash Miniconda2-latest-Linux-x86_64.sh -b \
 && rm Miniconda2-latest-Linux-x86_64.sh

ENV PATH /home/ubuntu/miniconda2/bin:$PATH

RUN cd /home/ubuntu \ 
    && wget https://cran.r-project.org/src/base/R-3/R-3.4.3.tar.gz && tar -xf R-3.4.3.tar.gz \
    && cd R-3.4.3 \
    && ./configure --with-x=no --with-cairo=yes --with-libpng=yes --enable-R-shlib --prefix=$HOME \
    && make

RUN conda install -y jupyter \
    && cd /home/ubuntu \
    && wget https://s3.us-east-2.amazonaws.com/brown-cbc-amis/jupyter_notebook_config.py \
    && wget https://s3.us-east-2.amazonaws.com/brown-cbc-amis/jupyter_notebook_config.json \
    && jupyter notebook --generate-config \
    && yes | mv -f jupyter_notebook_config.* .jupyter/ \
    && wget https://s3.us-east-2.amazonaws.com/brown-cbc-amis/install_all_levi.R && ls && pwd && /bin/bash -c "/home/ubuntu/R-3.4.3/bin/Rscript install_all_levi.R" \
    && wget https://raw.githubusercontent.com/waldronlab/BrownCOBRE2018/master/notebooks_day2/BrownCOBREDay2Session1.ipynb \
    && wget https://raw.githubusercontent.com/waldronlab/BrownCOBRE2018/master/notebooks_day2/BrownCOBREDay2Session2.ipynb \
    && wget https://raw.githubusercontent.com/waldronlab/BrownCOBRE2018/master/notebooks_day2/BrownCOBREDay2Session3.ipynb

RUN screen -dm bash -c /home/ubuntu/miniconda2/bin/jupyter notebook --allow-root --ip 0.0.0.0