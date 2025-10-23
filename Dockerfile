FROM python:3.11-slim

# نصب وابستگی‌ها
RUN apt-get update && apt-get install -y \
    git gcc libpq-dev python3-dev build-essential \
    libssl-dev libffi-dev \
    libldap2-dev libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# کاربر odoo
RUN useradd -m -d /odoo -s /bin/bash odoo
WORKDIR /odoo
USER odoo

# دانلود Odoo 19
RUN git clone --depth 1 --branch 19.0 https://github.com/odoo/odoo.git odoo-src

# نصب پکیج‌ها
RUN pip install --no-cache-dir -r odoo-src/requirements.txt

# کپی config و addons
COPY --chown=odoo:odoo config/odoo.conf /etc/odoo/odoo.conf
COPY --chown=odoo:odoo addons/ /mnt/custom-addons/

EXPOSE 8069
VOLUME ["/var/lib/odoo", "/mnt/custom-addons"]

CMD ["python", "odoo-src/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
