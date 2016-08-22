# Andrew Huang <bluedrum@163.com>
CC = gcc
AR = ar rcv
ifeq ($(windir),)
EXE =
RM = rm -f
else
EXE = .exe
RM = del
endif

CFLAGS = -ffunction-sections -O3
LDFLAGS = -Wl,--gc-sections

all:libmincrypt.a mkbootimg$(EXE) unpackbootimg$(EXE) mkbootfs$(EXE)

static:libmincrypt.a mkbootimg-static$(EXE) unpackbootimg-static$(EXE) mkbootfs-static$(EXE)

libmincrypt.a:
	make -C libmincrypt

mkbootimg$(EXE):mkbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ -L. -lmincrypt $(LDFLAGS) -s

mkbootimg-static$(EXE):mkbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ -L. -lmincrypt $(LDFLAGS) -static -s

mkbootimg.o:mkbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -I. -Werror

unpackbootimg$(EXE):unpackbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -s

unpackbootimg-static$(EXE):unpackbootimg.o
	$(CROSS_COMPILE)$(CC) -o $@ $^ $(LDFLAGS) -static -s

unpackbootimg.o:unpackbootimg.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Werror

mkbootfs.o:mkbootfs.c
	$(CROSS_COMPILE)$(CC) -o $@ $(CFLAGS) -c $< -Icm_android_system_core_include -Werror

clean:
	$(RM) mkbootimg mkbootimg-static mkbootimg.o unpackbootimg unpackbootimg-static unpackbootimg.o mkbootimg.exe mkbootimg-static.exe unpackbootimg.exe unpackbootimg-static.exe mkbootfs mkbootfs.o mkbootfs.exe
	$(RM) libmincrypt.a Makefile.~
	make -C libmincrypt clean

