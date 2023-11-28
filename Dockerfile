FROM python:3.9
COPY debian-sources.list /etc/apt/sources.list
COPY pip.conf /root/.pip/pip.conf

# Compile and install ctransformers for Apple Silicon
RUN apt update && apt -y install gcc-11 g++-11 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 && \
    rm -rf /var/lib/apt/lists/* && \
    pip install ctransformers --no-binary ctransformers

RUN useradd -m -u 1000 user
WORKDIR /code

COPY ./requirements.txt /code/requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
USER user
COPY --link --chown=1000 *.py /code