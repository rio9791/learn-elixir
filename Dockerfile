FROM erlang:20

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.5.1" \
	LANG=C.UTF-8

RUN apt-get -y update \
    && apt-get -y install wget curl 

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="9a903dc71800c6ce8f4f4b84a1e4849e3433e68243958fd6413a144857b61f6a" \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean

RUN mkdir -p /tmp \
    && curl -sL https://deb.nodesource.com/setup_6.x -o /tmp/nodesource_setup.sh \
    && sh ./tmp/nodesource_setup.sh \ 
    && apt-get -y install nodejs build-essential

#RUN mkdir -p /root/.mix/archives \
    #&& mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN apt-get clean all

RUN ["mkdir", "-p", "/application"]
VOLUME ["/application"]

# Binds to port 8080
EXPOSE  8080

CMD ["iex"]
