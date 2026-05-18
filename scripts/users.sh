#!/bin/bash
set -e

OPERATOR_PASS="12345678"
TEACHER_PASS="12345678"
STUDENT_PASS="student123"

DEFAULT_USER=${SUDO_USER}

useradd -r -s /usr/sbin/nologin app
useradd -m -g operator -s /bin/bash operator
useradd -m -s /bin/bash teacher
useradd -m -s /bin/bash student

usermod -aG sudo teacher
usermod -aG sudo student

echo "operator:$OPERATOR_PASS" | sudo chpasswd
echo "teacher:$TEACHER_PASS" | sudo chpasswd
echo "student:$STUDENT_PASS" | sudo chpasswd

chage -d 0 operator
chage -d 0 teacher

SUDO_FILE="/etc/sudoers.d/operator"

bash -c "cat > $SUDO_FILE" <<EOF
operator ALL=(ALL) NOPASSWD: /bin/systemctl start mywebapp
operator ALL=(ALL) NOPASSWD: /bin/systemctl stop mywebapp
operator ALL=(ALL) NOPASSWD: /bin/systemctl status mywebapp
operator ALL=(ALL) NOPASSWD: /bin/systemctl restart mywebapp
operator ALL=(ALL) NOPASSWD: /bin/systemctl reload nginx
operator ALL=(ALL) NOPASSWD: /bin/systemctl stop nginx
operator ALL=(ALL) NOPASSWD: /bin/systemctl start nginx

student ALL=(ALL) NOPASSWD: /bin/systemctl restart mywebapp
student ALL=(ALL) NOPASSWD: /opt/mywebapp/scripts/system/upd_env.sh
EOF

chmod 440 $SUDO_FILE

chown -R app:app "/opt/mywebapp"
chmod -R 755 "/opt/mywebapp"

sudo usermod -L $DEFAULT_USER
#loginctl terminate-user $DEFAULT_USER

echo "USERS SCRIPT DONE"