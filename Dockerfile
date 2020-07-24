FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    cmake

RUN apk add    gfortran
RUN apk add    lapack-dev
RUN apk add    boost-dev
RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing   netcdf-fortran-dev

RUN git clone --depth 1 https://github.com/trilinos/Trilinos.git /trilinos

RUN mkdir /trilinos/build/
WORKDIR /trilinos/build

RUN cmake \
    -DTPL_ENABLE_MPI=ON \
    -DTPL_ENABLE_BLAS=OFF \
    -DTPL_ENABLE_Matio=OFF \
    -DTPL_ENABLE_X11=OFF \
    -DTrilinos_ENABLE_ALL_PACKAGES=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/trilinos/ \
    ..

RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/trilinos/ /opt/trilinos/

