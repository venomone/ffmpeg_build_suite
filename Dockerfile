FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,video

RUN apt-get update
RUN apt-get -y --no-install-recommends install cmake git-core autoconf automake build-essential mlocate pkg-config curl ca-certificates python3 python-is-python3 ninja-build meson frei0r-plugins-dev libfreetype-dev gnutls-dev libgme-dev libfribidi-dev libharfbuzz-dev libfreetype6-dev libopencore-amrnb-dev libopencore-amrwb-dev librubberband-dev r-cran-xml libsoxr-dev libspeex-dev libvo-amrwbenc-dev libxml2-dev libpqxx-dev libpq-dev libqt5svg5-dev libzvbi-dev libbluray-dev libfdk-aac-dev cargo

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
RUN update-ca-certificates

WORKDIR /app
COPY ./build-ffmpeg /app/build-ffmpeg

RUN AUTOINSTALL=yes /app/build-ffmpeg --enable-gpl-and-non-free --build --full-static

# Check shared library
RUN ! ldd /app/workspace/bin/ffmpeg
RUN ! ldd /app/workspace/bin/ffprobe
RUN ! ldd /app/workspace/bin/ffplay

FROM scratch

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,video

# Copy ffmpeg
COPY --from=build /app/workspace/bin/ffmpeg /ffmpeg
COPY --from=build /app/workspace/bin/ffprobe /ffprobe

CMD         ["--help"]
ENTRYPOINT  ["/ffmpeg"]
