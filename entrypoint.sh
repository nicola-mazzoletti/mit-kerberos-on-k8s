#!/bin/bash
set -e

: "${REALM:=EXAMPLE.COM}"
: "${KDC_HOST_ADDRESS:=localhost}"
: "${ADMIN_PASSWORD:=admin}"

CONFIG_DIR=/etc/kerberos/generated
mkdir -p "$CONFIG_DIR"

# Debug
echo "Using REALM=$REALM, KDC_HOST_ADDRESS=$KDC_HOST_ADDRESS"

# Generate configs from templates using envsubst
envsubst < /etc/kerberos/templates/krb5.conf.template > "$CONFIG_DIR/krb5.conf"
envsubst < /etc/kerberos/templates/kdc.conf.template > "$CONFIG_DIR/kdc.conf"
envsubst < /etc/kerberos/templates/kadm5_acl.conf.template > "$CONFIG_DIR/kadm5.acl"

# Copy to expected locations
cp "$CONFIG_DIR/krb5.conf" /etc/krb5.conf
cp "$CONFIG_DIR/kdc.conf" /etc/krb5kdc/kdc.conf
cp "$CONFIG_DIR/kadm5.acl" /etc/krb5kdc/kadm5.acl

# Initialize KDC database if missing
if [ ! -f /var/lib/krb5kdc/principal ]; then
    echo "Initializing KDC database..."
    echo -e "$ADMIN_PASSWORD\n$ADMIN_PASSWORD" | kdb5_util create -s -r "$REALM"
fi

# Start KDC and admin server
krb5kdc -n &
exec kadmind -nofork
