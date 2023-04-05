FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -qq -y \
    curl \
    python3-pip \
    git \
    build-essential \
    wget \
    libffi-dev \
    texlive-full \
    librsvg2-bin \
    openssh-client \
    && rm -fr /var/lib/apt/lists/*

RUN pip3 install --upgrade pip \
    && pip3 install \
    'PyYAML>=5.3.0,<6.0.0' \
    && pip3 install \
    mkdocs \
    mkdocs-material \
    mkdocs-merge \
    pydoc-markdown \
    markdown_katex \
    pandoc-latex-admonition \
    mkdocs-kroki-plugin \
    mkdocs-markmap \
    markdown-katex \
    git+https://gitlab.com/myriacore/pandoc-kroki-filter.git \
    git+https://github.com/twardoch/mkdocs-combine.git \
    && wget https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-linux-amd64.tar.gz \
    && tar xvzf pandoc-2.13-linux-amd64.tar.gz --strip-components 1 -C /usr/local/ \
    && rm pandoc-2.13-linux-amd64.tar.gz

RUN pydoc-markdown --version \
    && fc-cache -f

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

