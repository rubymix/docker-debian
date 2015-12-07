# rubymix/debian

My debain docker image for personal purpose.

## Quick start
```
docker run --rm -u ${UID}:${GROUPS} --net=host -v ~/projects:/workspace -t -i rubymix/debian
```