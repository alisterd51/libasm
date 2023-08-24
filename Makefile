all:
BUILD	:= debug

build_dir := ${BUILD}
srcs_dir := srcs

LIB	:= libasm.a
BIN_CHECK	:= test_libasm

libs	:= ${LIB}
exes	:= ${BIN_CHECK}

SRCS	:=
SRCS_CHECK	:= main.c

OBJS	:= ${SRCS:.s=.o}
OBJS_CHECK	:= ${SRCS_CHECK:.c=.o}

DEPS	:= ${OBJS:.o=.d}
DEPS_CHECK	:= ${OBJS_CHECK:.o=.d}

-include ${addprefix ${build_dir}/, ${DEPS} ${DEPS_CHECK}}

CC	:= clang
AS	:= clang
AR	:= ar rcs

CFLAGS.debug	:= -O0 -g3 -fsanitize=address -fsanitize=undefined -fsanitize=leak
CFLAGS.release	:= -O3
CFLAGS	:= -Wall -Wextra -Werror ${CFLAGS.${BUILD}}

LDLIBS	:=

LDFLAGS.debug	:= -g3 -fsanitize=address -fsanitize=undefined -fsanitize=leak
LDFLAGS.release	:= -O3
LDFLAGS	:= ${LDFLAGS.${BUILD}}

COMPILE.C	= ${CC} -MD -MP ${CFLAGS} -c $< -o $@
COMPILE.ASM	= ${AS} -MD -MP -c $< -o $@
LINK	= ${CC} ${LDFLAGS} ${filter-out Makefile, $^} ${LDLIBS} -o $@
ARCHIVE	= ${AR} $@ ${filter-out Makefile, $^}

all: ${libs:%=${build_dir}/%}

${build_dir}:
	mkdir $@

${build_dir}/%.o: ${srcs_dir}/%.c Makefile | ${build_dir}
	${strip ${COMPILE.C}}

${build_dir}/%.o: ${srcs_dir}/%.s Makefile | ${build_dir}
	${strip ${COMPILE.ASM}}

${build_dir}/${LIB}: ${addprefix ${build_dir}/, ${OBJS}} Makefile | ${build_dir}
	${strip ${ARCHIVE}}

${build_dir}/${BIN_CHECK}: ${addprefix ${build_dir}/, ${LIB} ${OBJS_CHECK}} Makefile | ${build_dir}
	${strip ${LINK}}

${LIB}: ${build_dir}/${LIB}

clean:
	rm -f ${addprefix ${build_dir}/, ${OBJS} ${DEPS}}

fclean:
	rm -rf ${build_dir}

re: fclean all

check: ${exes:%=${build_dir}/%}
	./${build_dir}/${BIN_CHECK}

.PHONY: all clean fclean re ${LIB}
