################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../private/assignToBins1.c \
../private/convOnes.c \
../private/histc2c.c \
../private/imtransform2_c.c \
../private/ktComputeW_c.c \
../private/ktHistcRgb_c.c \
../private/nlfiltersep_max.c \
../private/nlfiltersep_sum.c 

OBJS += \
./private/assignToBins1.o \
./private/convOnes.o \
./private/histc2c.o \
./private/imtransform2_c.o \
./private/ktComputeW_c.o \
./private/ktHistcRgb_c.o \
./private/nlfiltersep_max.o \
./private/nlfiltersep_sum.o 

C_DEPS += \
./private/assignToBins1.d \
./private/convOnes.d \
./private/histc2c.d \
./private/imtransform2_c.d \
./private/ktComputeW_c.d \
./private/ktHistcRgb_c.d \
./private/nlfiltersep_max.d \
./private/nlfiltersep_sum.d 


# Each subdirectory must supply rules for building sources it contributes
private/%.o: ../private/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


