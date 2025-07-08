# ====== Base Image ======
FROM odoo:18

# ====== Metadata ======
LABEL maintainer="nexifai"
LABEL description="Production-grade Odoo 18 container with pandas build dependencies"

# ====== Set User and Path ======
USER root
ENV PATH="/home/odoo/.local/bin:$PATH"

# Switch to root
USER root

# Add PGDG repository and install required system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    lsb-release \
    wget \
    gnupg && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    python3-dev \
    libffi-dev \
    libssl-dev \
    build-essential \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libxml2-dev \
    libxslt1-dev \
    libpq-dev \
    libsasl2-dev \
    libldap2-dev \
    libjpeg-dev \
    zlib1g-dev \
    git \
    sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ====== Configure odoo User ======
RUN usermod -s /bin/bash odoo && \
    echo "odoo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ====== Copy Requirements and Install Python Packages ======
COPY requirements.txt /home/odoo/requirements.txt
RUN pip install --break-system-packages --no-cache-dir -r /home/odoo/requirements.txt

# ====== Create Log Directory ======
RUN mkdir -p /var/log/odoo && chown -R odoo:odoo /var/log/odoo

# ====== Switch to odoo User ======
USER odoo

# ====== Optional: Developer Tools ======
RUN pip install --break-system-packages --no-cache-dir autopep8 debugpy coverage

# ====== Default Command ======
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]