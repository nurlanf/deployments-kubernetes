FROM gcr.io/google-appengine/debian9 as builder

ENV TMP=/opt/pg-bdr
ENV BDR_PLUGIN=1.0.2.tar.gz
ENV BDR_PG=REL9_4_12-1.tar.gz
ENV PG_VER=9.4


RUN set -ex; \
    apt-get update && \
	apt-get -y install \
    wget \
    ca-certificates \
    gnupg2

RUN set -ex; \
    mkdir $TMP \
    && cd $TMP \
    && wget https://github.com/2ndQuadrant/bdr/archive/bdr-pg/${BDR_PG} \
    && tar xzf ${BDR_PG} \
    && wget https://github.com/2ndQuadrant/bdr/archive/bdr-plugin/${BDR_PLUGIN} \
    && tar xzf ${BDR_PLUGIN} \
    && rm -rf ${BDR_PG} ${BDR_PLUGIN}

RUN set -ex; \
    echo "deb-src http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main ${PG_VER}" > \
    /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get -y build-dep postgresql-${PG_VER} \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    cd $TMP/bdr-bdr-pg-${BDR_PG%.tar.gz} \
    && ./configure --prefix=/usr/lib/postgresql/${PG_VER} --enable-debug --with-openssl \
    && make -j4 -s install-world

ENV PATH=/usr/lib/postgresql/${PG_VER}/bin:$PATH

RUN set -ex; \
    cd ${TMP}/bdr-bdr-plugin-${BDR_PLUGIN%.tar.gz} \
    && ./configure \
    && make -j4 -s all \
    && make -s install

RUN set -ex; \
    useradd postgres \
    && mkdir -p /var/lib/postgresql/ \
    && chown postgres:postgres /var/lib/postgresql \
    && usermod -d /var/lib/postgresql postgres

USER postgres

RUN set -ex; \
    initdb -D ~/${PG_VER}-bdr -A trust

COPY postgresql.conf /var/lib/postgresql/${PG_VER}-bdr

# CMD ["initdb", "-D", "~/9.4-bdr", "-A", "trust"]

