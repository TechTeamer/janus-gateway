# Fázis 1: JANUS COMPILE STAGE
FROM registry.access.redhat.com/ubi9/ubi-minimal AS compile

ENV JANUS_VERSION_COMMIT="bad60d7032026af453a98ed7aba7fbc083385ea2"
ENV UID=1000
ENV GID=1000
ENV DOCKER_USER="techteamer"

# Telepítési függőségek
COPY test/install /install

# Telepítsd a szükséges eszközöket
RUN microdnf -y update && \
    microdnf -y install dnf wget tar gcc-c++ make automake cmake libtool pkgconf && \
    cp /install/dnf/dnf.conf /etc/dnf/ && \
    cp /install/yum/CentOS.repo /etc/yum.repos.d/ && \
    cp /install/yum/RPM-GPG-KEY-centosofficial /etc/pki/rpm-gpg/ && \
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    rpm -Uvh https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm && \
    microdnf -y clean all && \
    rpm -e --nodeps openssl-fips-provider && \
    microdnf -y update && \
    microdnf -y install ffmpeg-devel libogg-devel jansson-devel openssl-devel glib2-devel libconfig-devel gengetopt gnutls-devel gtk-doc zlib-devel && \
    mkdir -p /workspace

# Libnice telepítése
RUN cd /workspace && \
    wget -q -O libnice-0.1.17.tar.gz https://github.com/libnice/libnice/archive/refs/tags/0.1.17.tar.gz && \
    tar xzf libnice-0.1.17.tar.gz && \
    rm libnice-0.1.17.tar.gz && \
    cd libnice-0.1.17 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Libsrtp telepítése
RUN cd /workspace && \
    wget -q https://github.com/cisco/libsrtp/archive/v2.5.0.tar.gz && \
    tar xzf v2.5.0.tar.gz && \
    rm v2.5.0.tar.gz && \
    cd libsrtp-2.5.0 && \
    ./configure --prefix=/usr/local --enable-openssl && \
    make shared_library && \
    make install

# Libwebsockets telepítése
RUN cd /workspace && \
    wget -q https://github.com/warmcat/libwebsockets/archive/v4.3.2.tar.gz && \
    tar xzf v4.3.2.tar.gz && \
    rm v4.3.2.tar.gz && \
    cd libwebsockets-4.3.2 && \
    mkdir build && cd build && \
    cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TESTAPPS=1 -DLWS_WITHOUT_CLIENT=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DCMAKE_C_FLAGS="-fpic" .. && \
    make && \
    make install

# PKG_CONFIG_PATH beállítása
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:${PKG_CONFIG_PATH}"

# Janus Gateway fordítása és telepítése
COPY . /workspace/janus-gateway
WORKDIR /workspace/janus-gateway

# Töröld a nem kívánt fájlokat és mappákat
RUN rm -rf .git .github .gitignore .gitattributes

RUN sh autogen.sh && \
    ./configure --enable-post-processing --disable-data-channels --disable-all-plugins --enable-plugin-echotest --enable-plugin-videoroom --disable-all-transports --enable-websockets && \
    make && \
    make install

# Fázis 2: BUILD STAGE
FROM registry.access.redhat.com/ubi9/ubi-minimal

ENV UID=1000
ENV GID=1000
ENV DOCKER_USER="techteamer"

COPY test/install /install
COPY --from=compile /usr/local /usr/local
COPY --from=compile /workspace/janus-gateway /workspace/janus-gateway

RUN sh -x /install/install-os.sh && \
    groupadd -g $GID $DOCKER_USER && \
    useradd -m -u $UID -g $DOCKER_USER $DOCKER_USER && \
    sh -x /install/install-supervisor.sh $DOCKER_USER && \
    sh -x /install/install-janus-runtime-env.sh && \
    [ ! -e /usr/local/lib/libsrtp2.so ] && ln -s /usr/local/lib/libsrtp2.so.1 /usr/local/lib/libsrtp2.so || echo "Link already exists" && \
    [ ! -e /usr/local/lib/libnice.so.10 ] && ln -s /usr/local/lib/libnice.so.10.10.0 /usr/local/lib/libnice.so.10 || echo "Link already exists" && \
    [ ! -e /usr/local/lib/libnice.so ] && ln -s /usr/local/lib/libnice.so.10.10.0 /usr/local/lib/libnice.so || echo "Link already exists" && \
    [ ! -e /usr/local/lib/libwebsockets.so ] && ln -s /usr/local/lib/libwebsockets.so.19 /usr/local/lib/libwebsockets.so || echo "Link already exists"

WORKDIR /workspace
CMD ["bash", "-c", "cd /workspace/test && ./check_janus.sh"]
