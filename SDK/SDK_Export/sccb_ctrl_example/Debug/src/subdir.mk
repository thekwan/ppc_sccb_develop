################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/main.c \
../src/platform.c \
../src/sccb.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/main.o \
./src/platform.o \
./src/sccb.o 

C_DEPS += \
./src/main.d \
./src/platform.d \
./src/sccb.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo Building file: $<
	@echo Invoking: PowerPC gcc compiler
	powerpc-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../sccb_ctrl_example_bsp/ppc440_0/include -mcpu=440 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


