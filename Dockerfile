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
    # 'PyYAML>=5.3.0,<6.0.0' does not longer work because of cython upgrade
    # see: https://github.com/yaml/pyyaml/issues/724
    && pip3 install 'cython<3.0.0' \
    && pip3 install --no-build-isolation 'PyYAML==6.0' \
    && pip3 install \
    mkdocs \
    mkdocs-material \
    mkdocs-merge \
    pydoc-markdown \
    markdown_katex \
    pandoc-latex-admonition \
    mkdocs-kroki-plugin \
    mkdocs-markmap \
    mkdocs-meta-descriptions-plugin \
    mkdocs-mermaid2-plugin \
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
