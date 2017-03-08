TARGET = Socle_SH_nonOS
CC = ../gcc-arm-none-eabi-4_9-2015q2/bin/arm-none-eabi-gcc
AR = ../gcc-arm-none-eabi-4_9-2015q2/bin/arm-none-eabi-ar
CFLAGS = -Wall -O2 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS += -mlittle-endian -mthumb -nostartfiles -mcpu=cortex-m4
ifdef APSS
CFLAGS += -DAPSS
TARGET := $(subst SH,AP,$(TARGET))
else
CFLAGS += -DSHSS
endif
ifdef FreeRTOS
CFLAGS += -DFreeRTOS
TARGET := $(subst nonOS,FreeRTOS,$(TARGET))
endif
DIR = ./
DIR += Driver/MailboxControl/incl
DIR += Driver/TokenHelper/incl
DIR += Framework/Basic_Defs_API/incl
DIR += Framework/CLib_Abstraction_API/incl
DIR += Framework/Device_API/incl
#DIR += Framework/DMAResource_API/incl
DIR += Log/incl
DIR += Adapter/Adapter_VAL/incl
DIR += Driver/MailboxControl/src
DIR += Driver/TokenHelper/src
DIR += Log/src
DIR += Log/src/printf
DIR += Adapter/Adapter_VAL/src
DIR += Adapter/Adapter_VEX/src
DIR += Adapter/Adapter_Generic/src
ifdef VALTEST	#for test tool
DIR += TestTool/ValTests
DIR += TestTool/TestVectors/src
DIR += TestTool/TestVectors/incl
TARGET := $(addsuffix _test, $(TARGET))
endif
INCS = $(patsubst %, -I %, $(DIR))
SRC = $(wildcard $(addsuffix /*.c, $(DIR)))
OBJ = $(SRC:.c=.o)

.PHONY: all clean cleanall
all: $(TARGET) clean
$(TARGET): $(OBJ)
    #$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(AR) rcs lib$@.a $^ 

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCS) -o $@ $<

clean:
	@rm -rf $(OBJ)
	
cleanall:
	@rm -rf lib*.a $(OBJ)
