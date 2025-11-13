FROM ubuntu:24.04

RUN apt-get update -y && apt-get install -y --no-install-recommends \
	gettext-base \
	krb5-admin-server \
	krb5-kdc \
	krb5-user

RUN mkdir -p /etc/kerberos/templates

COPY ./templates/krb5.conf.template /etc/kerberos/templates
COPY ./templates/kdc.conf.template /etc/kerberos/templates
COPY ./templates/kadm5_acl.conf.template /etc/kerberos/templates

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
