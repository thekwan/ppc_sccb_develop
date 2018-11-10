/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 */

#include <stdio.h>
#include "platform.h"
#include "sccb.h"

#define OV7670_DEV_SLAVE_ADDR 0x42

void print(char *str);

int main()
{
	u8 reg;
    init_platform();

    print("*****************************************\n\r");
    print("* SCCB protocol Test Program            *\n\r");
	sccb_reset( OV7670_DEV_SLAVE_ADDR );
	//sccb_write_reg( 0xb4 , 0x5a );
	reg = sccb_read_reg( 0x0A );
    print(" PID reg value = 0x");
	putnum( reg );
    print("\n\r");
	reg = sccb_read_reg( 0x0B );
    print(" VER reg value = 0x");
	putnum( reg );
    print("\n\r");
    print("*****************************************\n\r");

    cleanup_platform();


    return 0;
}
