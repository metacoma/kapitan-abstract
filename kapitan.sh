WORK_DIR=/kapitan-data
KAPITAN_VERSION=0.26.0


docker run -e DEBUG --rm -it       \
  -v `pwd`:${WORK_DIR}    \
  -w ${WORK_DIR}          \
  deepmind/kapitan:${KAPITAN_VERSION} $*
	
