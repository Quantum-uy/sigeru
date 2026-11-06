FROM mysql:8.0

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

CMD ["sh", "-c", "while true; do /usr/local/bin/backup.sh; sleep 21600; done"]
